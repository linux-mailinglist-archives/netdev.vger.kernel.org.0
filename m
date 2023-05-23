Return-Path: <netdev+bounces-4554-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 94AE870D36B
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 07:55:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4F8A0281249
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 05:55:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C7991B90D;
	Tue, 23 May 2023 05:55:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E79D1B8F1
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 05:55:25 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96809115;
	Mon, 22 May 2023 22:55:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=f9sp9X29rgCQutb1zyE01/AbOq
	vvWhdCJdNJmWOTdpGbrPMqnfPwdWtXyJItgUJklC82G5xiqj0mrMp5gXWlrUyIeXR+Mo++eDaMld4
	tWsVWKUUVdFiL9GEbmNRBORxElvBLme8vx5TTV6tYdjJ1e5eSV/VbS43P+Khj8kMOh1O1PmULkLJL
	0OOzVdMaikHhPYDVaCp6lILsdt3BDSSS47fwmWLB1b9IJk0UQN9gdlYyugYZbkMVru3EO8fQg0G+G
	R7W4esEGccYKZIxg5UNd3i+kRa2lJcm+3kpcPRdptBLx2RRxWT1S+kucCJVOfA0C6e6Y7HByMAMiS
	62Q8eALw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1q1Kz2-0091FK-2G;
	Tue, 23 May 2023 05:54:56 +0000
Date: Mon, 22 May 2023 22:54:56 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Kees Cook <keescook@chromium.org>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	James Smart <james.smart@broadcom.com>,
	Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Sagi Grimberg <sagi@grimberg.me>,
	HighPoint Linux Team <linux@highpoint-tech.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Don Brace <don.brace@microchip.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Guo Xuenan <guoxuenan@huawei.com>,
	Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Daniel Latypov <dlatypov@google.com>,
	kernel test robot <lkp@intel.com>, intel-wired-lan@lists.osuosl.org,
	netdev@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, megaraidlinux.pdl@broadcom.com,
	storagedev@microchip.com, linux-xfs@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	Tales Aparecida <tales.aparecida@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] overflow: Add struct_size_t() helper
Message-ID: <ZGxVMAa/3QOd3cRf@infradead.org>
References: <20230522211810.never.421-kees@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230522211810.never.421-kees@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


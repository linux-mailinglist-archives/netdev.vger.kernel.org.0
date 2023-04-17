Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94E796E3E73
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 06:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbjDQEYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 00:24:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjDQEYh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 00:24:37 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C307211B;
        Sun, 16 Apr 2023 21:24:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=PDTJ8vrV/ZSnzPwihhoSPZPy4j8shliYbZRXCXdGPtc=; b=2919Ubu5U3OGXVFavm5v2vae6z
        d956R6FKwriDSkjqLTwnK0YdSXj2Ecv7uUwKWnG/HzIwqHRuyGt1dhWOJ7dhvNtLP2D/+aDnsvIwK
        Cw7ZIMkcI+q+ZX4Oq5tGeoPzMELkzlzFoyritFYFaM2aqt2NlP1+yQ/2sObs+8cYPZmcA4+lsYUcs
        4/LYSd3oQ1yJlLeP/cUY6TJ3ZyItTBX5hF2M75F1t/O/H9A+MSct7H11u7RcPqMtrhvaOVQC0r3CZ
        lLC7VPJpPrUBg4tjcHV6VlPGT6YQCCZZYHBdr0XOy6Sl9+BiEyckH8gKyuXgQtQKey8I0LxgOLQUm
        0zezI97Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1poGPo-00EpWW-2m;
        Mon, 17 Apr 2023 04:24:32 +0000
Date:   Sun, 16 Apr 2023 21:24:32 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     netdev@vger.kernel.org,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH net-next] xsk: introduce xsk_dma_ops
Message-ID: <ZDzKAD2SNe1q/XA6@infradead.org>
References: <20230417032750.7086-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230417032750.7086-1-xuanzhuo@linux.alibaba.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 17, 2023 at 11:27:50AM +0800, Xuan Zhuo wrote:
> The purpose of this patch is to allow driver pass the own dma_ops to
> xsk.

Drivers have no business passing around dma_ops, or even knowing about
them.

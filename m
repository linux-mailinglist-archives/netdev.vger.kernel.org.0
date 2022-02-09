Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6DBA4AEB10
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 08:32:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237785AbiBIHcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 02:32:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233454AbiBIHcE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 02:32:04 -0500
X-Greylist: delayed 468 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 08 Feb 2022 23:32:06 PST
Received: from asav22.altibox.net (asav22.altibox.net [109.247.116.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5031C05CB8F;
        Tue,  8 Feb 2022 23:32:06 -0800 (PST)
Received: from canardo.mork.no (207.51-175-193.customer.lyse.net [51.175.193.207])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: bmork@altiboxmail.no)
        by asav22.altibox.net (Postfix) with ESMTPSA id A9F3620B9F;
        Wed,  9 Feb 2022 08:24:15 +0100 (CET)
Received: from miraculix.mork.no ([IPv6:2a01:799:c9f:8602:8cd5:a7b0:d07:d516])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 2197OEnx4109351
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Wed, 9 Feb 2022 08:24:15 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1644391455; bh=vq0fAEMjE3aQLMTv+FYGe6trzD/BxE5XYMfH6WcCoRU=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=DXZG7CXOPojy00CvGvE3DKCcxwLBrSfMcZkbBR0ObwdlDL4GhLdUeYkvxJ+fsc6eq
         tyfNy4jBZySRzpyxUMuh7T6rCWJvc3dMD6/cxLKUaEmYoECX3x8fXzi2blGJG+aI+E
         V0mH4va53HyAD8/wHgSpFI3zVb6kaUpJC7PdFEhU=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94.2)
        (envelope-from <bjorn@mork.no>)
        id 1nHhKo-002RsF-7R; Wed, 09 Feb 2022 08:24:14 +0100
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Slark Xiao <slark_xiao@163.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: usb: qmi_wwan: Add support for Dell DW5829e
Organization: m
References: <20220209024717.8564-1-slark_xiao@163.com>
Date:   Wed, 09 Feb 2022 08:24:14 +0100
In-Reply-To: <20220209024717.8564-1-slark_xiao@163.com> (Slark Xiao's message
        of "Wed, 9 Feb 2022 10:47:17 +0800")
Message-ID: <8735ksv6xt.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.103.3 at canardo
X-Virus-Status: Clean
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.3 cv=KbX8TzQD c=1 sm=1 tr=0
        a=XJwvrae2Z7BQDql8RrqA4w==:117 a=XJwvrae2Z7BQDql8RrqA4w==:17
        a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=oGFeUVbbRNcA:10 a=M51BFTxLslgA:10
        a=Byx-y9mGAAAA:8 a=qTnbSId5lU9I7QlpegkA:9 a=QEXdDO2ut3YA:10
        a=Uq1aMm8mgZsA:10 a=NWVoK91CQyQA:10 a=3la3ztWH3XQaG4dFsChN:22
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Slark Xiao <slark_xiao@163.com> writes:

> Dell DW5829e same as DW5821e except the CAT level.
> DW5821e supports CAT16 but DW5829e supports CAT9.
> Also, DW5829e includes normal and eSIM type.

Acked-by: Bj=C3=B8rn Mork <bjorn@mork.no>

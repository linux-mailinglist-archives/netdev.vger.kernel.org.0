Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8CCA3CFAA1
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 15:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238408AbhGTMxk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 08:53:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238802AbhGTMtN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 08:49:13 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2FFCC061574;
        Tue, 20 Jul 2021 06:29:51 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id g8so29901808lfh.8;
        Tue, 20 Jul 2021 06:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5UusRkdsoT638YfSrAAm+TVTQJyejuNWHoXYbs2aNFE=;
        b=qBXL47tAt4Zhi3Yd8Laq9Iv0M6oQfmUkVQlf2pVWBHQ2nH/z/Au/S+KXpocQtUrh+v
         PyCG1FMUjuirVkcuhmBrtRD1sJUp2WlJ9wy2WYn884wXLORm9t0rZq2h5WAwcNL4m9KN
         oXrXAWKruMt5Y+Nopl6V0156ENBlDdafi5gIU/lhIDq8yzxyNJxEaizXBznL8PadV2cD
         s2IbOxsh0wvPgmehevPtKxkpJSlJQBvD4Yc/b49VlgNQ+w6jczLrM1jA56+HhrgT+A4P
         xGB/9m+lIwufMKXt+G9XKJgmPgHGu+qBzTIJY5niruFhTcLUH2nLfUDA7T4DbL+Fznic
         JieQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5UusRkdsoT638YfSrAAm+TVTQJyejuNWHoXYbs2aNFE=;
        b=E7aLB/sKGrJMd/wY7vqRLpKhGLXRZEC8cPzjDGDZn9LVLG6JcWAVPWCb8quR8AEH5H
         msps65rDI+hb9iNqK0W3xh8uABrLbC9aLLAbx0tusQmOoGaMAYNr69MBLCsoTXT5C+v1
         wUSshMwAvkYQy7eEgtsfo6J/UZ7dYZ6lECu8747oOoDB/DeL/qkirlULtiJfmE5drC9S
         aF1DLCry9KRFln5o0pPdB/usk8SszszRsViMfXYJ8tk32hYPPY/IMFZ76rvuYLkvye3T
         MvdzxSNkMx75FAkSWjOwTx0cz/GCZxYz1us6hv5DdcQRZt4C/sWOshRMWF8m0NFBw1nn
         u3Ng==
X-Gm-Message-State: AOAM532QvsvdMPyeQ919dcmIMA9KuP/1D35WF8S9+AIwWxSY1Wdv8ZjW
        Ijumb+lzhF7NXKBdGSHGNH+c91Zi7c/Dgw==
X-Google-Smtp-Source: ABdhPJx54AumcK1aald87HvFI2CB2CceO6HF64yEFUpmxmKeV7JKahWEznr+npQiq9ZtzffnLETwqg==
X-Received: by 2002:ac2:5e28:: with SMTP id o8mr20803519lfg.209.1626787790369;
        Tue, 20 Jul 2021 06:29:50 -0700 (PDT)
Received: from home.paul.comp (paulfertser.info. [2001:470:26:54b:226:9eff:fe70:80c2])
        by smtp.gmail.com with ESMTPSA id x12sm730335lji.117.2021.07.20.06.29.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jul 2021 06:29:49 -0700 (PDT)
Received: from home.paul.comp (home.paul.comp [IPv6:0:0:0:0:0:0:0:1])
        by home.paul.comp (8.15.2/8.15.2/Debian-14~deb10u1) with ESMTP id 16KDTlCw005209;
        Tue, 20 Jul 2021 16:29:48 +0300
Received: (from paul@localhost)
        by home.paul.comp (8.15.2/8.15.2/Submit) id 16KDThZf005208;
        Tue, 20 Jul 2021 16:29:43 +0300
Date:   Tue, 20 Jul 2021 16:29:43 +0300
From:   Paul Fertser <fercerpav@gmail.com>
To:     Ivan Mikhaylov <i.mikhaylov@yadro.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        Joel Stanley <joel@jms.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        openbmc@lists.ozlabs.org
Subject: Re: [PATCH v2 3/3] net/ncsi: add dummy response handler for Intel
 boards
Message-ID: <20210720132943.GG875@home.paul.comp>
References: <20210708122754.555846-1-i.mikhaylov@yadro.com>
 <20210708122754.555846-4-i.mikhaylov@yadro.com>
 <20210720094113.GA4789@home.paul.comp>
 <b1da28a76c249637d6f094b046d851c7622e71d4.camel@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b1da28a76c249637d6f094b046d851c7622e71d4.camel@yadro.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 20, 2021 at 04:21:31PM +0300, Ivan Mikhaylov wrote:
> Paul, I know about 'get mac address' and it was in my todo list. You can put it
> before or after this patch series whenever you want, it doesn't interfere with
> this one. Anyways, thanks for sharing it.

The patch in question modifies the same file in the same place, see:

diff --git a/net/ncsi/ncsi-rsp.c b/net/ncsi/ncsi-rsp.c
index a94bb59793f0..b36c22ec4c3f 100644
--- a/net/ncsi/ncsi-rsp.c
+++ b/net/ncsi/ncsi-rsp.c
...
 static struct ncsi_rsp_oem_handler {
        unsigned int    mfr_id;
        int             (*handler)(struct ncsi_request *nr);
 } ncsi_rsp_oem_handlers[] = {
        { NCSI_OEM_MFR_MLX_ID, ncsi_rsp_handler_oem_mlx },
-       { NCSI_OEM_MFR_BCM_ID, ncsi_rsp_handler_oem_bcm }
+       { NCSI_OEM_MFR_BCM_ID, ncsi_rsp_handler_oem_bcm },
+       { NCSI_OEM_MFR_INTEL_ID, ncsi_rsp_handler_oem_intel }
 };

And your patch:

Signed-off-by: Ivan Mikhaylov <i.mikhaylov@yadro.com>
---
 net/ncsi/ncsi-rsp.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/ncsi/ncsi-rsp.c b/net/ncsi/ncsi-rsp.c
index 04bc50be5c01..d48374894817 100644
--- a/net/ncsi/ncsi-rsp.c
+++ b/net/ncsi/ncsi-rsp.c
...
 static struct ncsi_rsp_oem_handler {
        unsigned int    mfr_id;
        int             (*handler)(struct ncsi_request *nr);
 } ncsi_rsp_oem_handlers[] = {
        { NCSI_OEM_MFR_MLX_ID, ncsi_rsp_handler_oem_mlx },
-       { NCSI_OEM_MFR_BCM_ID, ncsi_rsp_handler_oem_bcm }
+       { NCSI_OEM_MFR_BCM_ID, ncsi_rsp_handler_oem_bcm },
+       { NCSI_OEM_MFR_INTEL_ID, ncsi_rsp_handler_oem_intel }
 };

so it does conflict. I suggest if you decide to continue with this
series rather than the userspace solution to include the MAC fetching
patch in your submission instead of the stub handler.

--
Be free, use free (http://www.gnu.org/philosophy/free-sw.html) software!
mailto:fercerpav@gmail.com

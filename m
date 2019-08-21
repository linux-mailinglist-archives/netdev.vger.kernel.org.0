Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF5F396E4F
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 02:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbfHUAYT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 20:24:19 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:38802 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726202AbfHUAYT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 20:24:19 -0400
Received: by mail-qt1-f193.google.com with SMTP id x4so952893qts.5
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 17:24:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=wdyamSDauWIr/8a3miDFCrsaWTOv07ZufwSzJmECkaA=;
        b=PmfpY1p/MHmnf7pk/Ybd3bCBfsbumJKkpiCD2v0BhzGcb+ghClJwLf21ZPpJ6EnSmK
         CvOBSed3p9CDY2kOOHUutadWvcuV2RHEUQOecIokWJoKBoeyrjbUzWNNR8RbG5dOgpO1
         dSKOhfLpiyh/aD1RzaSGiyek+Re1j191b5VxO1KONH9YiS9U87gafXlL+89LPrl5mdh7
         GE4CZCR2kEqUpjV3FNLSbFIfxi8gBlHVloXypqzBl7MDhs1++hBAGZEjksPZWZl41IMN
         A7DgBBjjgyFLAu32TaGk+BCyYrypvd6FOXkrEcICzDq6q7O/uJnwfMz/ri4Fka6pqI56
         /Xvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=wdyamSDauWIr/8a3miDFCrsaWTOv07ZufwSzJmECkaA=;
        b=uThq/U3AJ8RzjQF9fBIOi5anPftDcbrlpofh5TXLr0DG57uabo9vluC2/JYterB+HX
         ryKVpBhAsclPWlT5uTLuBMAud9T9MRcddG5NRWXHYSLudS0eB0DFyV4c9A/pHyX2wpIh
         ZJ54hGF1s9YqLbioObHoWXJBt3ZReOIeEVNt44RHnaysquzcVmUUCeWgJHlHq4yckhbs
         nX7jd56M+HLgdKo012iaVufnlAYMvyEXtFJJSaQ0psfkXFYKnJjbocR45udBwkau7CxM
         26uu4axcf6kJaZzbTY1FmE2Ys3HZesGaELPg4cHiqA5e+Yk/3nAAh0McHyV7ElWIvkTC
         cqzw==
X-Gm-Message-State: APjAAAV8KBC5/nOTERVmbU1DUkOzwXTschB+snlid7ROAAgpTryxWX1S
        ywTGaLI45TwQCk/cTPtd1Cv363hAI20=
X-Google-Smtp-Source: APXvYqxADHLuI8mV55blgXK8YW6aNmC/VZ0OdHOLoyBM5RqkURZ7pb4ULC9S2YIcqMg/1+EsbyCxlg==
X-Received: by 2002:ac8:e45:: with SMTP id j5mr29298099qti.149.1566347058062;
        Tue, 20 Aug 2019 17:24:18 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id n21sm11223841qtc.70.2019.08.20.17.24.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2019 17:24:17 -0700 (PDT)
Date:   Tue, 20 Aug 2019 17:24:11 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
Subject: Re: various TLS bug fixes...
Message-ID: <20190820172411.70250551@cakuba.netronome.com>
In-Reply-To: <20190820.160517.617004656524634921.davem@davemloft.net>
References: <20190820.160517.617004656524634921.davem@davemloft.net>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Aug 2019 16:05:17 -0700 (PDT), David Miller wrote:
> Jakub,
> 
> I just did a batch of networking -stable submissions, however I ran
> into some troubles with the various TLS backports.

Yes, the TLS back ports are a little messy :S

> I was able to backport commit 414776621d10 ("net/tls: prevent
> skb_orphan() from leaking TLS plain text with offload") to v5.2
> but not to v4.19

We can probably leave that out of v4.19. The only practical scenario
where the issue occurs to my knowledge is if admin configured TC
redirect, or netem in the setup. Let me know if you'd rather we did the
backport, I'm not 100% sure the risk/benefit ratio is favourable.

> I was not able to backport neither d85f01775850 ("net: tls, fix
> sk_write_space NULL write when tx disabled") nor commit 57c722e932cf
> ("net/tls: swap sk_write_space on close") to any release.  It seems
> like there are a bunch of dependencies and perhaps other fixes.

Right, those should still be applicable but John and I rejigged 
the close path quite a bit. I think the back port would be this:

diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 4c0ac79f82d4..3288bdff9889 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -301,6 +301,8 @@ static void tls_sk_proto_close(struct sock *sk, long timeout)
 #else
        {
 #endif
+               if (sk->sk_write_space == tls_write_space)
+                       sk->sk_write_space = ctx->sk_write_space;
                tls_ctx_free(ctx);
                ctx = NULL;
        }

> I suspect you've triaged through this already on your side for other
> reasons, so perhaps you could help come up with a sane set of TLS
> bug fix backports that would be appropriate for -stable?

I'm planning to spend tomorrow working exactly on v4.19 backport. 
I have internal reports of openssl failing on v4.19 while v4.20 
works fine.. Hopefully I'll be able to figure that one out, test the
above and see if there are any other missing fixes.

Is it okay if I come back to this tomorrow?

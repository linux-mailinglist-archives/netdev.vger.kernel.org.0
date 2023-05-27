Return-Path: <netdev+bounces-5902-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 76CE27134E9
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 15:10:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 293E2281252
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 13:10:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2664711CA9;
	Sat, 27 May 2023 13:10:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 184C3F9E2
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 13:10:00 +0000 (UTC)
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8680A10A;
	Sat, 27 May 2023 06:09:58 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id 5b1f17b1804b1-3f6da07ff00so18066445e9.3;
        Sat, 27 May 2023 06:09:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685192997; x=1687784997;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=dvsLtNhlfL+kHe9BSiqT/A+Q9kXCPHk0gZKozzO0bJM=;
        b=WLrKljfLhF8WFYgrKC/y30tAA2pSGGKV4VcMofR7v5HD8z8ltP7IC/WjFxokWL7HgF
         Ir59YLn1mkvjIstCVoM9VWRoNNS1Hcg55ZYOlsJHc9P99nTnQIkpxUg3A7XXWO81BfBB
         QZKfTbYaQcupe8Acqw/5YjKSjCYq0op1G1zVVNNMz7dSDqe3hz82EfdvsQ9jXseWVX81
         3BTvivONwmpZs+7EbHmzBrSo88qXEkEaq7RZT/GeenA0fL1nc6D0MG6huWaMEPDt9TL6
         0OXrm1uwPPdgWzlokG2DuGW2Ym44B3HMnVAVQFdEtSOCsROQjT5wmmaW2RRHkXKoMDMl
         1s8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685192997; x=1687784997;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dvsLtNhlfL+kHe9BSiqT/A+Q9kXCPHk0gZKozzO0bJM=;
        b=FBDQNnHrPjtKx1MdWer67BJy4n1/F8aMCPq4SIoJpcZ3dyTnX7/Sj+s1hK2bMeY6qh
         RXwHj+QQcyhpzUjgNOLV3DC/iH6WdPzJ0ols0ANEhrFs76XwYtb9ASKEoXL4teWikgZ2
         YKLy4LVPs5S8FSGtABtKHVY7G2KIQFivQehjXDa8ocdczcMZj7vX+dAXsSKqPPSXnAPo
         +NT+VNChckTJK6D70/z+azs9/HEn9hcoKxetCLshpyiwyLgusex0lOkkf0tKYATvK9+b
         EeOuYSsPv9QDR5GTCyCeQ6phFSTUbMRBgrLdMRcNNcfciCNfbY6zbXPrnX3/dRG+Xdoe
         1Rfw==
X-Gm-Message-State: AC+VfDxIDm6udd6z8IEG7sDAH8Y5ne4Zglbl061nJPt72Y02GNQRIjth
	FG2XzS2Vu3Bz+RPhR8WIedo=
X-Google-Smtp-Source: ACHHUZ6Di1EVMVg8fhpYJlJ/Zx/4oQfPI5BKRlP7kb/227vNEI/3wULi2RrPXkmBNdC3bmJK6GS10g==
X-Received: by 2002:a05:600c:d5:b0:3f5:ce2:9c82 with SMTP id u21-20020a05600c00d500b003f50ce29c82mr4700669wmm.32.1685192996652;
        Sat, 27 May 2023 06:09:56 -0700 (PDT)
Received: from Ansuel-xps. (93-34-93-173.ip49.fastwebnet.it. [93.34.93.173])
        by smtp.gmail.com with ESMTPSA id l22-20020a1c7916000000b003f607875e5csm12005664wme.24.2023.05.27.06.09.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 May 2023 06:09:56 -0700 (PDT)
Message-ID: <64720124.1c0a0220.67a2a.c3cc@mx.google.com>
X-Google-Original-Message-ID: <ZHH73fg9HdlPVB58@Ansuel-xps.>
Date: Sat, 27 May 2023 14:47:25 +0200
From: Christian Marangi <ansuelsmth@gmail.com>
To: Simon Horman <simon.horman@corigine.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	wireguard@lists.zx2c4.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [net PATCH] wireguard: allowedips: fix compilation warning for
 stack limit exceeded
References: <20230526204134.29058-1-ansuelsmth@gmail.com>
 <ZHIAibPKikGjLD8+@corigine.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZHIAibPKikGjLD8+@corigine.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, May 27, 2023 at 03:07:21PM +0200, Simon Horman wrote:
> On Fri, May 26, 2023 at 10:41:34PM +0200, Christian Marangi wrote:
> > On some arch (for example IPQ8074) and other with
> > KERNEL_STACKPROTECTOR_STRONG enabled, the following compilation error is
> > triggered:
> > drivers/net/wireguard/allowedips.c: In function 'root_remove_peer_lists':
> > drivers/net/wireguard/allowedips.c:80:1: error: the frame size of 1040 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]
> >    80 | }
> >       | ^
> > drivers/net/wireguard/allowedips.c: In function 'root_free_rcu':
> > drivers/net/wireguard/allowedips.c:67:1: error: the frame size of 1040 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]
> >    67 | }
> >       | ^
> > cc1: all warnings being treated as errors
> > 
> > Since these are free function and returns void, using function that can
> > fail is not ideal since an error would result in data not freed.
> > Since the free are under RCU lock, we can allocate the required stack
> > array as static outside the function and memset when needed.
> > This effectively fix the stack frame warning without changing how the
> > function work.
> > 
> > Fixes: Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
> 
> nit: Not sure if this can be fixed-up manually.
>      But one instance of 'Fixes: ' is enough.
> 

An oversight by me sorry. Will send v2 with the tag fixed after 24
hours. Totally fine if the patch is OK to fix this when it's merged by
the maintainers.

-- 
	Ansuel


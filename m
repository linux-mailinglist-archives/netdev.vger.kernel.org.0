Return-Path: <netdev+bounces-208-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EB0996F5E06
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 20:35:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B2C6B1C20FD4
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 18:35:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EE01BE41;
	Wed,  3 May 2023 18:35:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15CEBE40
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 18:35:41 +0000 (UTC)
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF5B67D94
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 11:35:31 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id 41be03b00d2f7-517ab9a4a13so5073233a12.1
        for <netdev@vger.kernel.org>; Wed, 03 May 2023 11:35:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1683138931; x=1685730931;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gALeAFrNmGJwrYDmq/GkarDPGdyaXkn2+Q3xnV0Cu3s=;
        b=p5aqd9HhfhhBkmL6IVx4XuZn4m3n32o7bdWCXEwm+sQJj/Vp0riRGa5s4XplyB/6wL
         +pwECNDyalqkoIF7lQLscNw08msySvafyrt8twSR8XnjdZ+peRwDIz5n+gKW615nSsHv
         ltA0yvJAS3//N4to7qEy54H8m58YGfrLuXbrT8doimPlA/xhWLQdKNuypd+k8UWvxWer
         lq9ognysHWRcP9Zd3Zw4Ijv/EBCdZKtOi5GcFYkVCB8MO/zaET1W3hj/dg1gs0aAoqW/
         7yDFIk9pygjRbv2RNF7S23RqmYhomDBjFK3b/JfbXSeyGn5C03HlTFa7yiLlN4k9kpqL
         2PPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683138931; x=1685730931;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gALeAFrNmGJwrYDmq/GkarDPGdyaXkn2+Q3xnV0Cu3s=;
        b=LnD9Xoc4X2F71mLTN0j20ZZ3O4p0x7aKazg+oxdwkzUiUg6Ncv3Q2AethMEoW49k1G
         KBKHc951TGDms5wplhpdQQ7CCRZPtzVye53UafBemvDm0CS3Xg0ulgt4aeLL62SZmkEJ
         ph9HDEDDXx/z6tVK1yFH1H2AKrCsHVGO52SVNPTnws4n0stlgxcBgvpAT6SHkigWG5mV
         VUkehTKiCPe8qDhBxUKDTNlxH/QVDB9DOAR4gAyEhhZYOgPwJpFf26jTPTI1tUPB+awf
         eud6QPu0T8hy2fTUefxpkoHipsv0m4bzRP81Kgp561N09HnpQAAuvDl8Bl2oCyGVksXK
         soMw==
X-Gm-Message-State: AC+VfDz2K5Iw9wxM5CcxDJa1J/NNy+a6p7+a+qUK2wCWVpEOh9rvh3Qv
	aO6/ivDoedGx78ce6MBME2dAvA==
X-Google-Smtp-Source: ACHHUZ622jeraV3pm1ppF+Dx8vot4ErUrYtHY8bCeLvq9TJxPWWpCgPvOoUZkvhRcynBaGdHcxzLZg==
X-Received: by 2002:a17:90b:1e4f:b0:247:9d19:311f with SMTP id pi15-20020a17090b1e4f00b002479d19311fmr23523249pjb.30.1683138931087;
        Wed, 03 May 2023 11:35:31 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id d4-20020a170903230400b001a072aedec7sm8219424plh.75.2023.05.03.11.35.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 May 2023 11:35:30 -0700 (PDT)
Date: Wed, 3 May 2023 11:35:28 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Aleksey Shumnik <ashumnik9@gmail.com>
Cc: netdev@vger.kernel.org, waltje@uwalt.nl.mugnet.org, Jakub Kicinski
 <kuba@kernel.org>, gw4pts@gw4pts.ampr.org, kuznet@ms2.inr.ac.ru,
 "willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>,
 gnault@redhat.com
Subject: Re: [BUG] Dependence of routing cache entries on the ignore-df flag
Message-ID: <20230503113528.315485f1@hermes.local>
In-Reply-To: <CAJGXZLjLXrUzz4S9C7SqeyszMMyjR6RRu52y1fyh_d6gRqFHdA@mail.gmail.com>
References: <CAJGXZLjLXrUzz4S9C7SqeyszMMyjR6RRu52y1fyh_d6gRqFHdA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, 3 May 2023 18:01:03 +0300
Aleksey Shumnik <ashumnik9@gmail.com> wrote:

> Might you answer the questions:
> 1. How the ignore-df flag and adding entries to the routing cache is
> connected? In which kernel files may I look to find this connection?
> 2. Is this behavior wrong?
> 3. Is there any way to completely disable the use of the routing
> cache? (as far as I understand, it used to be possible to set the
> rhash_entries parameter to 0, but now there is no such parameter)
> 4. Why is an entry added to the routing cache if a suitable entry was
> eventually found in the arp table (it is added directly, without being
> temporarily added to the routing table)?

What kernel version. The route cache has been completely removed from
the kernel for a long time.


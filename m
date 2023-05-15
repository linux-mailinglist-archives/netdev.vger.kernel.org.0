Return-Path: <netdev+bounces-2529-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EC6C7025C2
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 09:12:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 14A3D1C20A47
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 07:12:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35E1979FA;
	Mon, 15 May 2023 07:12:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28CD779F6
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 07:12:37 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F04210F8
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 00:12:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684134755;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xwF3bMtKzTBdMVk3tiqEPsRCHZdEoAnjzKN67iE7ThU=;
	b=huMcrnHTpcxOYc/brtNEhEIbtjGgW3YLGQQZacxvfJ6KZCrSb/KH2+RLSeK+kd3ZDMcrg7
	5z2HvtsIa8RHKrhosxAxM+VJgOiswOS75p2LKziTkSjpe6RCpuhNbdZhFJhVRRmxocNWpI
	uFF8bE3FGyX596yFMkhSv15zR4q11bI=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-577-84IUaB9IOECh7Dz4AjEbDQ-1; Mon, 15 May 2023 03:12:33 -0400
X-MC-Unique: 84IUaB9IOECh7Dz4AjEbDQ-1
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-50d89279d95so22336360a12.1
        for <netdev@vger.kernel.org>; Mon, 15 May 2023 00:12:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684134752; x=1686726752;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xwF3bMtKzTBdMVk3tiqEPsRCHZdEoAnjzKN67iE7ThU=;
        b=a0TkPApkifZ31CSs11FPF8XesSxKx8zXt26m25w/F16Vef5OIhMmYSbuO3JtWXDlNn
         cHJeNjFBQeGo0+L4xFhvF3zY+tj7EP5/kPg/h29kHW0k8OeNPWqP9VvKUHEsXeMyfQ8E
         HMDLho22ZEj/ZOYNNXWL6U8FKPV1UeTqwME8Cw9kmLRsMYojfInr4Y4DSgtoFzf6aW7w
         SMlcQ/KnN4Swh7eLjJSiZrr8tSLJgmveTZlLRpmAZbnU/WTVb+c/FqwZ83Ueh7GcoaN4
         cyZ2ztVUmLSKz2A9rsW+pvRRxg7sNgqw9r89fwksr8jHhUjlLEx6cBYD37fv/9F3eftN
         0LKA==
X-Gm-Message-State: AC+VfDzgJjawswBV34U5jCY4TfBGgAQWkVEajUZnuZ/o5yA+pyMMTjni
	upeM0scsqdi3GSRomOphMmtxbnTQ11S8/b5tccKmPVWxja0VoRWRC/o/3d6UYwZ2BREAMpzVbFd
	MWA2PCLaBp4AbXqBn
X-Received: by 2002:a17:907:2d0e:b0:967:13a3:d82c with SMTP id gs14-20020a1709072d0e00b0096713a3d82cmr24677037ejc.26.1684134752853;
        Mon, 15 May 2023 00:12:32 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6roqpg5jE0hXDmdOedggiZFhhlASXlWjExoRB/ZX0m8zeiDXY1K7sjvx8CPHbp5waK9vPFwQ==
X-Received: by 2002:a17:907:2d0e:b0:967:13a3:d82c with SMTP id gs14-20020a1709072d0e00b0096713a3d82cmr24677011ejc.26.1684134752575;
        Mon, 15 May 2023 00:12:32 -0700 (PDT)
Received: from [10.39.192.162] (5920ab7b.static.cust.trined.nl. [89.32.171.123])
        by smtp.gmail.com with ESMTPSA id f20-20020a17090660d400b00965ac8f8a3dsm9178766ejk.173.2023.05.15.00.12.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 May 2023 00:12:31 -0700 (PDT)
From: Eelco Chaudron <echaudro@redhat.com>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Pravin B Shelar <pshelar@ovn.org>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
 netdev@vger.kernel.org, dev@openvswitch.org
Subject: Re: [RESEND PATCH net-next] net: openvswitch: Use struct_size()
Date: Mon, 15 May 2023 09:12:30 +0200
X-Mailer: MailMate (1.14r5964)
Message-ID: <7EFC8D77-C24C-433E-8E8B-FBCF4387A7CC@redhat.com>
In-Reply-To: <e7746fbbd62371d286081d5266e88bbe8d3fe9f0.1683388991.git.christophe.jaillet@wanadoo.fr>
References: <e7746fbbd62371d286081d5266e88bbe8d3fe9f0.1683388991.git.christophe.jaillet@wanadoo.fr>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 13 May 2023, at 9:25, Christophe JAILLET wrote:

> Use struct_size() instead of hand writing it.
> This is less verbose and more informative.
>
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Change looks good to me.

Acked-by: Eelco Chaudron <echaudro@redhat.com>



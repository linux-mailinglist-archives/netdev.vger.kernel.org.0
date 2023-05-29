Return-Path: <netdev+bounces-6162-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 178A7714F8D
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 21:14:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A67B71C20A53
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 19:14:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A628BE55;
	Mon, 29 May 2023 19:14:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F312A7C
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 19:14:12 +0000 (UTC)
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BED93AD
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 12:14:11 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id d75a77b69052e-3f6c229b42bso17685651cf.0
        for <netdev@vger.kernel.org>; Mon, 29 May 2023 12:14:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685387651; x=1687979651;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=juvPxapNyDL8wctdd1qOQ7lI6AvVfHL2Ju8YjORT5zo=;
        b=sDulM8YWdJTJiINJBZUeN0D/9Tc5T/1jy9p0W32xhcn4dLwrqS+obzAzeCtWyJwAYa
         71069UcyanbQ6uw7qJ5FUSX3Cx2vuSdJSU2UqA1u8bczL7q64DWRS9OUp6Onl5eVF3KP
         EWZWGIKwMwDshIsUd8wuoTO4a50rLHUdDQlFPX+Ipkiw0Vagcob0ikMYUqAV5sFlirsj
         uXUsRiMTnZwRJ/H774v7CWBsGVFUkIPFQvsHhogUxEimwwY7odwVut1X/1sw4NXDx88O
         oZK+GEE/YI7En0CU8Wo4zupznLF/5B0aU18b48/pPa7GLf2TPuuw0QphEC7btFy8VnN5
         0J7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685387651; x=1687979651;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=juvPxapNyDL8wctdd1qOQ7lI6AvVfHL2Ju8YjORT5zo=;
        b=OcCc0HqjFBX4jHqWLllaz6xpl5hWi+XaWSYUE7OmMPevqX7NKBjzRN6gOhV1nc4UdL
         Qr4jQEsfQGmLFloc+Pj92zkWs6R8HiigMUWpyE6ME6Bo262GOJunFWIo2Vt0eCsoVReE
         BPkcD8zGZ+axJlNmv2o6uaHkfS4fOCjKQC4pLQqbLs1x/an0+t95T7kArVZDHzV+sCEd
         hScQ7qkworkcBdzCTxcsLkM+ZNKpi+s0Sdn1XOuGo/92O4y2YIfi23uxJTGnVztzU+pP
         +ljLQvlypqkRKf14Rd1mMItfn/Wrn1aDYVDW28JrgekzRxrSZexqJkb+/Bu7sEdUV5Pz
         v8PA==
X-Gm-Message-State: AC+VfDx1x8YxaUDMy3vNwvcXKVfTPQW+nWQd+cBPTrAJOOP7TywOpW81
	mYicxWKI602xePCsk8IiyA==
X-Google-Smtp-Source: ACHHUZ6x9TpTkqVF8s+E9KZOTBtF2mkaatBE3wIez2dzm33VGPDXVFHJ3yW56g9MNvpN3R7DqQ82oQ==
X-Received: by 2002:ac8:5c49:0:b0:3f6:b923:b58d with SMTP id j9-20020ac85c49000000b003f6b923b58dmr11796781qtj.27.1685387650789;
        Mon, 29 May 2023 12:14:10 -0700 (PDT)
Received: from C02FL77VMD6R.googleapis.com ([2600:1700:d860:12b0:e554:e6:7140:9e6b])
        by smtp.gmail.com with ESMTPSA id l13-20020ac8724d000000b003f4ed0ca698sm4054548qtp.49.2023.05.29.12.14.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 12:14:10 -0700 (PDT)
Date: Mon, 29 May 2023 12:14:04 -0700
From: Peilin Ye <yepeilin.cs@gmail.com>
To: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Vlad Buslov <vladbu@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
	Pedro Tammela <pctammela@mojatatu.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>,
	Peilin Ye <peilin.ye@bytedance.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Hillf Danton <hdanton@sina.com>, netdev@vger.kernel.org,
	Cong Wang <cong.wang@bytedance.com>
Subject: Re: [PATCH v5 net 6/6] net/sched: qdisc_destroy() old ingress and
 clsact Qdiscs before grafting
Message-ID: <ZHT5fHBDys5WfTlH@C02FL77VMD6R.googleapis.com>
References: <faaeb0b0-8538-9dfa-4c1e-8a225e3534f4@mojatatu.com>
 <CAM0EoM=3iYmmLjnifx_FDcJfRbN31tRnCE0ZvqQs5xSBPzaqXQ@mail.gmail.com>
 <CAM0EoM=FS2arxv0__aQXF1a7ViJnM0hST=TL9dcnJpkf-ipjvA@mail.gmail.com>
 <7879f218-c712-e9cc-57ba-665990f5f4c9@mojatatu.com>
 <ZHE8P9Bi6FlKz4US@C02FL77VMD6R.googleapis.com>
 <20230526193324.41dfafc8@kernel.org>
 <ZHG+AR8qgpJ6/Zhx@C02FL77VMD6R.googleapis.com>
 <CAM0EoM=xLkAr5EF7bty+ETmZ3GXnmB9De3fYSCrQjKPb8qDy7Q@mail.gmail.com>
 <87jzwrxrz8.fsf@nvidia.com>
 <CAM0EoMkS+F5DRN=NOuuA0M1CCCmMYdjDpB1Wz2wjW=eJzHvC0w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAM0EoMkS+F5DRN=NOuuA0M1CCCmMYdjDpB1Wz2wjW=eJzHvC0w@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 29, 2023 at 09:55:51AM -0400, Jamal Hadi Salim wrote:
> On Mon, May 29, 2023 at 8:06 AM Vlad Buslov <vladbu@nvidia.com> wrote:
> > On Sun 28 May 2023 at 14:54, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> > > Why dont we push the V1 patch in and then worry about getting clever
> > > with EAGAIN after? Can you test the V1 version with the repro Pedro
> > > posted? It shouldnt have these issues. Also it would be interesting to
> > > see how performance of the parallel updates to flower is affected.
> >
> > This or at least push first 4 patches of this series. They target other
> > older commits and fix straightforward issues with the API.
> 
> Yes, lets get patch 1-4 in first ...

Sure, I'll send 1-4 as v6 first.

Thanks,
Peilin Ye



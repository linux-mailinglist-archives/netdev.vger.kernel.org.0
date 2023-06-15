Return-Path: <netdev+bounces-11163-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 105AF731CF0
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 17:46:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E875C1C20EA5
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 15:46:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D017F17AD1;
	Thu, 15 Jun 2023 15:46:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C438317AAD
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 15:46:12 +0000 (UTC)
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47F46123
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 08:46:06 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id 41be03b00d2f7-54f85f8b961so3597760a12.3
        for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 08:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1686843966; x=1689435966;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PMqv+K05RJ1ZdEkKbLhDvyQPc5QhL86ao5z2DZo8Am4=;
        b=CXs/G4Q95HdEUlJTCMnsaCVPkxGWRuXm3zU7I1Fca7zVWMhw9SHGtwmIArUVXt4+LA
         2lVBJpR50iscMRmZm/M8bcAKN5V4oEBSbashlFIaSHdxeu3FpJQm/Rjk7zi/zt4a/iV0
         wZENONMkCEhfuEoC++q1lIkfPMoMUa2ZAYMvVzi6ZapkxtSVECbPADoe6N9NOhKWbb6C
         1hXRzlQvF6f/YEIyK60GgHLUIn6EfiA7sQQ8hxqcdFCcE+VtVYKltljydElLLMNN1GJn
         qIbrU0xmLOg1XjDqNGL2OiRwP2gelekAGLJEAvoajUMx3Adam4e1yyB6vB5d6xqyRq2t
         ny8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686843966; x=1689435966;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PMqv+K05RJ1ZdEkKbLhDvyQPc5QhL86ao5z2DZo8Am4=;
        b=WDz7zsgvMBs7x3DL2/gSyrxCURkmkYb6TyukHmMbdtAQtk1zvR7cWemYheBmG+OKNZ
         ElbfnHId1D8yKb7Dwkn5E6o7lt9ZcIUVZKkxJvBBzLBiRZEItcv7/WWVpsLWo7/Wq2Lo
         wUclspmF5z93gnLRS3vxMcitcjPYP+EU1oUfQUjML0FogxhXrGAJ2Rlgh4ZuUbNqPNGh
         P3n9NUaqnAJ+WqXVEQSqjXSiNBUI3rSPYe+Wo+MnCBlVhV3JpmCpO5TPlNGjUELmIs/g
         kRZp11fsuS6B0zYFtmeyyfK4VbizrzqKK5pRTVjvDExYpV/e26m1B+ILfjhQDA4iNvCW
         djCQ==
X-Gm-Message-State: AC+VfDwtq5G4WRlukOe+tmXiT7RNVm0xHEGFTiO2XW9rkQsZQUjNepVq
	5JdM3WG6wBzl+sDQHeaIjSw+Ncawu1r+3ioInEbUJm+/
X-Google-Smtp-Source: ACHHUZ5oSiepelBv8ZZHZQkOO4ztbLpacpuLHDYlqBXC88apBvdLWDsRL5PkZNDTs53d/l2zKl8Eog==
X-Received: by 2002:a17:90a:8682:b0:24e:4b1c:74d2 with SMTP id p2-20020a17090a868200b0024e4b1c74d2mr5013782pjn.32.1686843965679;
        Thu, 15 Jun 2023 08:46:05 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id e5-20020a17090ab38500b0025bb1bdb989sm9539665pjr.29.2023.06.15.08.46.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jun 2023 08:46:05 -0700 (PDT)
Date: Thu, 15 Jun 2023 08:46:03 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Marcin Szycik <marcin.szycik@linux.intel.com>
Cc: netdev@vger.kernel.org, dsahern@gmail.com, Michal Swiatkowski
 <michal.swiatkowski@linux.intel.com>
Subject: Re: [PATCH iproute2-next] f_flower: implement pfcp opts
Message-ID: <20230615084603.20d04815@hermes.local>
In-Reply-To: <a22c8701-0663-2c27-d866-492e7655fe5e@linux.intel.com>
References: <20230614091758.11180-1-marcin.szycik@linux.intel.com>
	<20230614095458.54140ac7@hermes.local>
	<a22c8701-0663-2c27-d866-492e7655fe5e@linux.intel.com>
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

On Thu, 15 Jun 2023 10:36:51 +0200
Marcin Szycik <marcin.szycik@linux.intel.com> wrote:

> On 14.06.2023 18:54, Stephen Hemminger wrote:
> > On Wed, 14 Jun 2023 11:17:58 +0200
> > Marcin Szycik <marcin.szycik@linux.intel.com> wrote:
> >   
> >> +static void flower_print_pfcp_opts(const char *name, struct rtattr *attr,
> >> +				   char *strbuf, int len)
> >> +{
> >> +	struct rtattr *tb[TCA_FLOWER_KEY_ENC_OPT_PFCP_MAX + 1];
> >> +	struct rtattr *i = RTA_DATA(attr);
> >> +	int rem = RTA_PAYLOAD(attr);
> >> +	__be64 seid;
> >> +	__u8 type;
> >> +
> >> +	parse_rtattr(tb, TCA_FLOWER_KEY_ENC_OPT_PFCP_MAX, i, rem);
> >> +	type = rta_getattr_u8(tb[TCA_FLOWER_KEY_ENC_OPT_PFCP_TYPE]);
> >> +	seid = rta_getattr_be64(tb[TCA_FLOWER_KEY_ENC_OPT_PFCP_SEID]);
> >> +
> >> +	snprintf(strbuf, len, "%02x:%llx", type, seid);
> >> +}
> >> +  
> > 
> > NAK you need to support JSON output.
> > Also whet if kernel gives partial data.  
> 
> Hmm... when we were adding GTP opts parsing, you requested to remove JSON
> support [1]. Are you sure you want us to add it here?
> 
> Could you elaborate about partial data? Are there any similar functions
> which properly handle partial data?
> 
> [1] https://lore.kernel.org/netdev/20220127091541.6667d4d1@hermes.local


The handling of JSON in flower needs lots of cleanup work, not related to this patch.
So changing my mind. This patch is OK, it just continues existing unique model of
handling.

Ideally, there would not be all the special case handling of JSON in flower.
And the code would be more robust about getting partial attributes back from
the kernel.  Other parts of tc are not as brittle.


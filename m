Return-Path: <netdev+bounces-8083-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E940722A24
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 17:02:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BB442280EBF
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 15:02:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BFBD1F924;
	Mon,  5 Jun 2023 15:02:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EEE11F169
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 15:02:23 +0000 (UTC)
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E261F3
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 08:02:21 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-65311774e52so1543918b3a.3
        for <netdev@vger.kernel.org>; Mon, 05 Jun 2023 08:02:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1685977341; x=1688569341;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OO58eKmVoWNsJKlnEQ40hLV33QS8rL9+7/JiEiwU3VQ=;
        b=wNwI0FdhDQtPsD4p3JIxN6jRJlBNj/+C5EVNx5TKsfXIlvR2EGL0GSlBFv0SzqDYJQ
         eGc0+2YJv8nleUC+bOfqZgRorTp3saC/myeSFjVAdxoHqure5aWIS+ug+eWnyufedeVs
         MfEM8NSpPDrn3gEWCea0XkxJ8VlN2uRtSMAX931I+UiCZkYfWNwLHG/zIy9N2bTGqOQ0
         Bk71/PF/c9VEM0Jrl3TxOyxiiNwymG1Bsl5E+HiEdJ/0K4qbMTH+QMS3vedkRF+X80na
         PAvLA3j+91PYnmGmmlN1pVe8CB9h3Lxoehe/MjeMEvYytPLxo/2xUXc9L3dJ18YuZwxj
         hung==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685977341; x=1688569341;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OO58eKmVoWNsJKlnEQ40hLV33QS8rL9+7/JiEiwU3VQ=;
        b=R50A+1wPHcPANkDv6l01s+U6Xng3D98Wr0vtsk/M8xPmscCS/yYuDT9J0oGK4BjYnU
         DzRIpE694LteWMPf58YjCkifMhBwyDb57belzd5JIOkang32Y37SXjdOAWlUewE6NnEm
         pnFR+pRN0p2BexfaDMqVRl/Efoa0oaM36LWStAExoSLwR4kh1bciRuCVqOJm58mQ3JUx
         9W2t5IVGqBPJa+E0K1Yh+ga6v+3if+RrJyQIoWcjTh95xeHv+Tw93QjTqXvKW7q5sJeE
         DY37sytHxyHPEP9rXGp+SvIBFc8pwdLDc+dAtBAJBIeaayIrW1RbOIx+0ZjcirETKui0
         3Wtw==
X-Gm-Message-State: AC+VfDz34GvXwPmNqwRceDvhVvJaDjrDkVGkaUhysVfbBth+NTV9SqwE
	4P7iOXBItuqMK93JhV7Icco8/w==
X-Google-Smtp-Source: ACHHUZ74qqJ7F9OGrEO1EpIxpyLjKfsjK0pa3GifYIyQvvkaGIsxWklU/tgpW4fZ0vK8b7+hB+Uwgg==
X-Received: by 2002:a05:6a00:881:b0:641:d9b:a444 with SMTP id q1-20020a056a00088100b006410d9ba444mr15624597pfj.31.1685977340938;
        Mon, 05 Jun 2023 08:02:20 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id v3-20020aa78083000000b0062bc045bf4fsm5524750pff.19.2023.06.05.08.02.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 08:02:19 -0700 (PDT)
Date: Mon, 5 Jun 2023 08:02:17 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Ido Schimmel <idosch@idosch.org>
Cc: Vladimir Nikishkin <vladimir@nikishkin.pw>, netdev@vger.kernel.org,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, eng.alaamohamedsoliman.am@gmail.com, gnault@redhat.com,
 razor@blackwall.org, idosch@nvidia.com, liuhangbin@gmail.com,
 eyal.birger@gmail.com, jtoppins@redhat.com
Subject: Re: [PATCH iproute2-next v7] ip-link: add support for nolocalbypass
 in vxlan
Message-ID: <20230605080217.441e1973@hermes.local>
In-Reply-To: <ZH2cUO7pFnU/tcXL@shredder>
References: <20230604140051.4523-1-vladimir@nikishkin.pw>
	<ZH2CeAWH7uMLkFcj@shredder>
	<87sfb6pfqh.fsf@laptop.lockywolf.net>
	<ZH2cUO7pFnU/tcXL@shredder>
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

On Mon, 5 Jun 2023 11:26:56 +0300
Ido Schimmel <idosch@idosch.org> wrote:

> On Mon, Jun 05, 2023 at 02:47:12PM +0800, Vladimir Nikishkin wrote:
> > 
> > Ido Schimmel <idosch@idosch.org> writes:
> >   
> > > On Sun, Jun 04, 2023 at 10:00:51PM +0800, Vladimir Nikishkin wrote:  
> > >> Add userspace support for the [no]localbypass vxlan netlink
> > >> attribute. With localbypass on (default), the vxlan driver processes
> > >> the packets destined to the local machine by itself, bypassing the
> > >> userspace nework stack. With nolocalbypass the packets are always
> > >> forwarded to the userspace network stack, so userspace programs,
> > >> such as tcpdump have a chance to process them.
> > >> 
> > >> Signed-off-by: Vladimir Nikishkin <vladimir@nikishkin.pw>
> > >> ---  
> > >> v6=>v7:  
> > >> Use the new vxlan_opts data structure. Rely on the printing loop
> > >> in vxlan_print_opt when printing the value of [no] localbypass.  
> > >
> > > Stephen's changes are still not present in the next branch so this patch
> > > does not apply  
> > 
> > Sorry for the confusion, I thought that the tree to develop against is
> > git://git.kernel.org/pub/scm/linux/kernel/git/shemminger/iproute2.git  
> 
> iproute2-next is developed at
> git://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git
> 
> See the README file.
> 
> Anyway, patch looks fine, but indentation is a bit off. Please fold this
> in:

David will to a merge from main to next if asked.



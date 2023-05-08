Return-Path: <netdev+bounces-910-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B5916FB58F
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 18:52:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9D6EA1C20A22
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 16:52:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0248F20F9;
	Mon,  8 May 2023 16:52:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C894424
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 16:52:20 +0000 (UTC)
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 412064C03;
	Mon,  8 May 2023 09:52:15 -0700 (PDT)
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-24e4e23f378so3369841a91.3;
        Mon, 08 May 2023 09:52:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683564734; x=1686156734;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lKlpAB8AKIxo4dSlH4+cwNzwviO7i4BXcMDofbP4/Y4=;
        b=VNYUsDpNxh8iUcl/Z+qy3L6GTWsvnbQrE8TZOflMUCT7Krg4Hp3tqfye6eVYkRjbI7
         hRMowKsZ9FYtne5q5YwNUJTA11384VA7QtmKmata04a/st3S98DlCcQzyAdEf5fSYg98
         fI/M6FAS+Vb3KIl51a/JILvEgnuWrMpoR2Rgg6IrnG0aZ36ORJ/pyngDT5WONDw9iHic
         POCFWZiYdj7tJykZnguy4WpylegsVVgpAYgrR/nriNv88gFblHt3hpfHwRq6ginubBQp
         ACXglcQfbUSoalNLyZpLcRmjXCiBDXcncXx8izrs1rPvX9b3qKEV9d0hK8SHrXycyAuK
         NqFQ==
X-Gm-Message-State: AC+VfDwG2UgEj44L6o6rnlaPflJ5gk6xAjEaQ9cRsLlg7zGOEpiBLlWJ
	tXx/427sSakEaNX743ap0Tw=
X-Google-Smtp-Source: ACHHUZ5YAZBJRuwObeE+RUnkQ/prDCWbYAQOh6GSzcmna/vKchpEna9OA/ygjsSnyZEa3ijepdKOrw==
X-Received: by 2002:a17:90a:880b:b0:250:484e:355f with SMTP id s11-20020a17090a880b00b00250484e355fmr8509250pjn.49.1683564734648;
        Mon, 08 May 2023 09:52:14 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([20.69.120.36])
        by smtp.gmail.com with ESMTPSA id f5-20020a170902ce8500b001ab016e7916sm7536143plg.234.2023.05.08.09.52.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 09:52:14 -0700 (PDT)
Date: Mon, 8 May 2023 16:52:12 +0000
From: Wei Liu <wei.liu@kernel.org>
To: Dexuan Cui <decui@microsoft.com>
Cc: "'bhelgaas@google.com'" <bhelgaas@google.com>,
	"'davem@davemloft.net'" <davem@davemloft.net>,
	"'edumazet@google.com'" <edumazet@google.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Jake Oshins <jakeo@microsoft.com>,
	"'kuba@kernel.org'" <kuba@kernel.org>,
	"'kw@linux.com'" <kw@linux.com>, KY Srinivasan <kys@microsoft.com>,
	"'leon@kernel.org'" <leon@kernel.org>,
	"'linux-pci@vger.kernel.org'" <linux-pci@vger.kernel.org>,
	"'lpieralisi@kernel.org'" <lpieralisi@kernel.org>,
	"Michael Kelley (LINUX)" <mikelley@microsoft.com>,
	"'pabeni@redhat.com'" <pabeni@redhat.com>,
	"'robh@kernel.org'" <robh@kernel.org>,
	"'saeedm@nvidia.com'" <saeedm@nvidia.com>,
	"'wei.liu@kernel.org'" <wei.liu@kernel.org>,
	Long Li <longli@microsoft.com>,
	"'boqun.feng@gmail.com'" <boqun.feng@gmail.com>,
	Saurabh Singh Sengar <ssengar@microsoft.com>,
	"'helgaas@kernel.org'" <helgaas@kernel.org>,
	"'linux-hyperv@vger.kernel.org'" <linux-hyperv@vger.kernel.org>,
	"'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
	"'linux-rdma@vger.kernel.org'" <linux-rdma@vger.kernel.org>,
	"'netdev@vger.kernel.org'" <netdev@vger.kernel.org>,
	Jose Teuttli Carranco <josete@microsoft.com>
Subject: Re: [PATCH v3 0/6] pci-hyper: Fix race condition bugs for fast
 device hotplug
Message-ID: <ZFkovIxZudoLISBv@liuwe-devbox-debian-v2>
References: <20230420024037.5921-1-decui@microsoft.com>
 <SA1PR21MB1335B7E8FFBE1C03E9B0FDE2BF609@SA1PR21MB1335.namprd21.prod.outlook.com>
 <SA1PR21MB13353B83E4DE3E6EEB62483ABF609@SA1PR21MB1335.namprd21.prod.outlook.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SA1PR21MB13353B83E4DE3E6EEB62483ABF609@SA1PR21MB1335.namprd21.prod.outlook.com>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Apr 21, 2023 at 10:23:03PM +0000, Dexuan Cui wrote:
> > From: Dexuan Cui
> > Sent: Thursday, April 20, 2023 7:04 PM
> > > ...
> > >
> > > Dexuan Cui (6):
> > >   PCI: hv: Fix a race condition bug in hv_pci_query_relations()
> > >   PCI: hv: Fix a race condition in hv_irq_unmask() that can cause panic
> > >   PCI: hv: Remove the useless hv_pcichild_state from struct hv_pci_dev
> > >   Revert "PCI: hv: Fix a timing issue which causes kdump to fail
> > >     occasionally"
> > >   PCI: hv: Add a per-bus mutex state_lock
> > >   PCI: hv: Use async probing to reduce boot time
> > >
> > >  drivers/pci/controller/pci-hyperv.c | 145 +++++++++++++++++-----------
> > >  1 file changed, 86 insertions(+), 59 deletions(-)
> > 
> > Hi Bjorn, Lorenzo, since basically this patchset is Hyper-V stuff, I would
> > like it to go through the hyper-v tree if you have no objection.
> > 
> > The hyper-v tree already has one big PCI patch from Michael:
> > https://git.kernel.org/pub/scm/linux/kernel/git/hyperv/linux.git/commit/?h=
> > hyperv-next&id=2c6ba4216844ca7918289b49ed5f3f7138ee2402
> > 
> > Thanks,
> > Dexuan
> 
> Hi Lorenzo, thanks for Ack'ing the patch:
>   Re: [PATCH v2] PCI: hv: Replace retarget_msi_interrupt_params with hyperv_pcpu_input_arg
> 
> It would be great if you and/or Bjorn can Ack this patchset as well :-)
> 

Lorenzo and Bjorn, are you happy with these patches? I can collect them
via the hyperv-fixes tree.

Thanks,
Wei.

> v1 of this patchset was posted on 3/28:
> https://lwn.net/ml/linux-kernel/20230328045122.25850-1-decui%40microsoft.com/
> and v3 got Michael Kelley's and Long Li's Reviewed-by.
> 
> I have done a long-haul testing against the patchset and it worked
> reliably without causing any issue: without the patchset, usually the VM
> can crash within 1~2 days; with the patchset, the VM is still running fine 
> after 2 weeks.
> 
> Thanks,
> Dexuan


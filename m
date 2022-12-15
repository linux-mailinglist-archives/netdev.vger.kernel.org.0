Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E379964DE25
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 16:59:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbiLOP7r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 10:59:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbiLOP7r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 10:59:47 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68E792DAAB
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 07:59:46 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id o1-20020a17090a678100b00219cf69e5f0so3177722pjj.2
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 07:59:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MBf1caY+vJltruM+ArRHdJ4WGldRjbLZwQ6n7WIGZYI=;
        b=ZBSgQGuBaZCxsYHFr9DJ27k+WtPb5Cyl808v5ESGAKN4PerC9kqb7zxnwwaFzKi8Ls
         YMGj8nx+/gYqc3DYgWdVuytutFBrbsHvZMLXK2Kkpu9tEuxS525s2gc2bGKmK4sdHCep
         8vJeD1hvoIatlFLvLQOiuFfUxHzSySD4MbhdMe9PFrNYZqeT0/kQ7bzPpoLgRKMkRMbF
         BIL4SjDOc2ndVTP60WlVZ/hKOUglEa6qGyyhRpcISqkWFoXp8uAign0zAymk8mupu8UN
         04BWZJM1C6WW12D6yq3I/7VZUta1z91bPgUngf0luR6aCVCJTKTymIjRLzmHmcH593Pw
         bbLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MBf1caY+vJltruM+ArRHdJ4WGldRjbLZwQ6n7WIGZYI=;
        b=E1H3sk9n8YVyNTur4Xj6pmvhEnHJNjPY7Ypt8ZMbK7+dZo+J4HUrlxH2MTSzKk0xmj
         QtXT2B8HxkPdCQcIUZKLwrTLQnlHSumA3JnQVDCfF/KzQcfqjo4ym9AgSIJxd+bPgBmi
         j29g4ZsxZZ0wYQ9NVQI2V8wHb/BwUQKJsprNL7iNoDrsZWPl90fm73Jw+vE2Qlh0voKW
         fp6s+rcbiO1V6uADGNSU07lbXRVtSXBVPuuz79w8ru/r6aHlMFvrvutLAP2MNYyOcuGZ
         +xJxKCImeuAc0c7CHLZdg0t8UAfdyB3VkK3d5/lVO336ubN53/MGWNRNMRXcrpCee8aM
         J4NA==
X-Gm-Message-State: AFqh2kqGTqsO56OI0o2b0aXX8vQ91dfA5E7/kqCfxJbThfIA/yPGlEUM
        lsHT8fg9odcgq2yyXUcqZfP58g==
X-Google-Smtp-Source: AMrXdXtxaXNgeAf/9RnWDhH4yqIAJkR4EbGpasSCAzdQb+liKpOyEMLswnBPmNqHLIe1QGY5SZREzA==
X-Received: by 2002:a17:903:25d1:b0:190:f82f:c937 with SMTP id jc17-20020a17090325d100b00190f82fc937mr1793217plb.42.1671119985797;
        Thu, 15 Dec 2022 07:59:45 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id t9-20020a1709027fc900b001888cadf8f6sm4010050plb.49.2022.12.15.07.59.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Dec 2022 07:59:45 -0800 (PST)
Date:   Thu, 15 Dec 2022 07:59:43 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     "Drewek, Wojciech" <wojciech.drewek@intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Missing patch in iproute2 6.1 release
Message-ID: <20221215075943.3f51def8@hermes.local>
In-Reply-To: <MW4PR11MB5776DC6756FF5CB106F3ED26FDE19@MW4PR11MB5776.namprd11.prod.outlook.com>
References: <MW4PR11MB5776DC6756FF5CB106F3ED26FDE19@MW4PR11MB5776.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 15 Dec 2022 10:28:16 +0000
"Drewek, Wojciech" <wojciech.drewek@intel.com> wrote:

> Hi Stephen,
> 
> I've seen iproute2 6.1 being released recently[1] and I'm wondering why my patch[2] was included.
> Is there anything wrong with the patch?
> 
> Regards,
> Wojtek
> 
> [1] https://lore.kernel.org/netdev/20221214082705.5d2c2e7f@hermes.local/
> [2] https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=9313ba541f793dd1600ea4bb7c4f739accac3e84

Iproute2 next tree holds the patches for the next release.
That patch went into the next tree after 6.1 was started.
It will get picked up when next is merged to main.

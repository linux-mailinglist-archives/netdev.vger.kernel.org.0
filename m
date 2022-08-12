Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DAA6591599
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 20:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239391AbiHLSod (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 14:44:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239379AbiHLSoc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 14:44:32 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88AAEB4407
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 11:44:30 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id gp7so1742530pjb.4
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 11:44:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc;
        bh=Jwz3JqA8E4VLI4fm3m0tXIUfFR+R/+giNaaOoAPVjoE=;
        b=scv94rzjTNbgITmmQH3RiWc35UVRfOskfK9mOBJ3Fe9p1cWAuHq3mFLLCp1tcPL3ej
         eHFnHjXjMtQ2AuvYO/2RjldsUrNkkVm42q7g4rg5kGir3Keq3ckwp+D05itvJppbKq5h
         yfSKz2zoDMtcurnDZEiUOAYbFf6UX/gN6GsQWRs4wX2Yuj19Caqg5t4z6mP4TEjeJJZ2
         UvJa1e2R4+eyc/bVSzyBZt3DT4tik22vdr9AsU1xCfZX0988xRTVRL1doMJdJsivrdKE
         gLW1xKDuhzRUKWDS8weuy+bLrQYl1wSg/twcCLNR9UPXViR20LDG9iHljXQxltw9iGlP
         UmMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=Jwz3JqA8E4VLI4fm3m0tXIUfFR+R/+giNaaOoAPVjoE=;
        b=oQps962DnWUbRu2upBvemfgTAmpEAxP4ZHSlyjFT3NAOHQjGNlCZMoTE//kG3Ugiqz
         bvQDyVyrpLM4nmVIHWfSJu4ebAhUIm9lQ3OBGaMXojeiIvDeY/6nlmt6SwCDAAAnh85n
         AaQ1YjiUUiVoL28DKv0nEUwB9ezizMU73HycCGS5KPy7A5dqMDCOw6W+D0e0PX9jLypW
         ZWXwBqigNUEtbXqH1gdmUnnZEO4feQF/1GEEmpy3opL89QQOWEgGZyMIIgY3yq0bUVqU
         H9odVsXdfdHm0CzGX2T1BkfFx2L5BuSJY2LXuiOJDcJZ07mxMgyi5z6E6PT2cqfiny5l
         BBbQ==
X-Gm-Message-State: ACgBeo1IRuCtMGWLw90bOVUWH+/P7pDwYyHRtuCs/kOKGwumNYLobViv
        7JHXIIPuUBZdJ/W383GcTlRkcg==
X-Google-Smtp-Source: AA6agR6o1q7JATkXSumgeEUJRB6X0YWlJ6SXRpkm2KPKcZbXqyEExH+p6Vaj89McpgGUQciCA1GidQ==
X-Received: by 2002:a17:902:ce90:b0:16e:f7c3:c478 with SMTP id f16-20020a170902ce9000b0016ef7c3c478mr5284938plg.82.1660329870008;
        Fri, 12 Aug 2022 11:44:30 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id i16-20020a056a00225000b0052e9cee1f5fsm1933037pfu.29.2022.08.12.11.44.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Aug 2022 11:44:29 -0700 (PDT)
Date:   Fri, 12 Aug 2022 11:44:27 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     Antonio Quartulli <antonio@openvpn.net>, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC v2] net: introduce OpenVPN Data Channel Offload (ovpn-dco)
Message-ID: <20220812114427.05f7393a@hermes.local>
In-Reply-To: <CAHNKnsQnHAdxC-XhC9RP-cFp0d-E4YGb+7ie3WymXVL9N-QS6A@mail.gmail.com>
References: <20220719014704.21346-2-antonio@openvpn.net>
        <20220803153152.11189-1-antonio@openvpn.net>
        <CAHNKnsQnHAdxC-XhC9RP-cFp0d-E4YGb+7ie3WymXVL9N-QS6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 12 Aug 2022 21:34:33 +0300
Sergey Ryazanov <ryazanov.s.a@gmail.com> wrote:

> What is the purpose of creating and destroying interfaces via RTNL,
> but performing all other operations using the dedicated netlink
> protocol?
> 
> RTNL interface usually implemented for some standalone interface
> types, e.g. VLAN, GRE, etc. Here we need a userspace application
> anyway to be able to use the network device to forward traffic, and
> the module implements the dedicated GENL protocol. So why not just
> introduce OVPN_CMD_NEW_IFACE and OVPN_CMD_DEL_IFACE commands to the
> GENL interface? It looks like this will simplify the userspace part by
> using the single GENL interface for any management operations.

RTNL is netlink. The standard way to create network devices should
be available with newlink message as in:

 # ip link add dev myvpn type ovpn <options>

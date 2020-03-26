Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 538EE194693
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 19:34:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728236AbgCZSe2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 14:34:28 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:44627 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727995AbgCZSe2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 14:34:28 -0400
Received: by mail-lj1-f195.google.com with SMTP id p14so7486043lji.11;
        Thu, 26 Mar 2020 11:34:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Qvltw6BbIljlptDziJDx+3Nqzbv74mwgS1caIyZyJQg=;
        b=TFeJEhdCEPi7VwXF/H8eJJt3cXZX7pONtl9zpMzXWNv/UoXloPbyCcjZhevebNEx0u
         8IAdq09+VIvhFJLPr/VbUl7TIywXJwKwc348h7BToxqySyTM+CbE2/y887DSaVO/tQsJ
         sy5D2oy/Cxo44tOMRW3juh7lylW6byzBUXUGjMLkj1+TQHRnD259Sg2y4THzOz/G2Qj0
         2E0v23scukAEDZJwGj/6QHZhHc6fptxvQ3EJNTOBf6ne3JSmwCQ8Fzz9erWwPxuJMfOF
         s2VP6CQWAPGVguewDsEExEBNm4TiQc0JdYeC/ENT/GH+dEJZU22FLQ3x6ujCvjW/ksdQ
         yCrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Qvltw6BbIljlptDziJDx+3Nqzbv74mwgS1caIyZyJQg=;
        b=rH4Ky04MYUX5FliglOvnWB3bjW2bJhyJecyuG4HUWIhpERhxECp7kKQ0O6UcNEHD/I
         Wpdomc6ay8orjw04Mh22yCB4k5LnmZaaAZgRmbZwn+jErvjXkYBVjStnwq8yLONN/lnR
         pcCfBR1A6CRlySIImJM//QXBUUoZv/ygvTmIOUfJzq1QbEZaN5EZEZwi2cTRsmg9jBrS
         JsOlJGzmvE5zy04H+qpDGcr4VTSKxy5uqf1JLJw3mbtrNu0vYHwa84e8sT2XUNuldErg
         hO7G+k4MLnb2vHnj8anoEDDaPep6ejDtLIxv4OPSeniwN2y9S6+A3wihu3nJxWSSfy4T
         U+LQ==
X-Gm-Message-State: AGi0PuaQCWSGk2dxXnGeoZajONFZmPX6owmR+0cdQ67xFwGoG1lLlZez
        Roezm2deweoq1adcJe2kRGZ9Q64L8GLW9Olla/w=
X-Google-Smtp-Source: ADFU+vu+SpIkmy3ikTRV7PMLFD4FWNRZFGTNLY+5Hm98SXkmutWm7RkuB7yWfFAUpFErAW4lDXZJcG3cgntW02vEpGE=
X-Received: by 2002:a2e:8084:: with SMTP id i4mr5982810ljg.185.1585247664310;
 Thu, 26 Mar 2020 11:34:24 -0700 (PDT)
MIME-Version: 1.0
References: <CAHo-OoxMNBTDZW_xqp1X3SGncM-twAySrdnc=ntS7_e2j0YEaA@mail.gmail.com>
 <20200326142803.239183-1-zenczykowski@gmail.com> <20200326113048.250e7098@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200326113048.250e7098@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Thu, 26 Mar 2020 11:34:14 -0700
Message-ID: <CAHo-OoxviTedR+dn5LaaKZtVWXR7bBTDzO23WfcB3kHGr6j48w@mail.gmail.com>
Subject: Re: [PATCH v2] iptables: open eBPF programs in read only mode
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>, Chenbo Feng <fengc@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> FWIW the BPF subsystem is about to break uAPI backward-compat and
> replace the defines with enums. See commit 1aae4bdd7879 ("bpf: Switch
> BPF UAPI #define constants used from BPF program side to enums").

Shouldn't it do what is normally done in such a case?
#define BPF_F_RDONLY BPF_F_RDONLY

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31FD26D30DA
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 14:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbjDAMwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 08:52:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjDAMwi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 08:52:38 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07F8DC15F;
        Sat,  1 Apr 2023 05:52:38 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id w4so23908871plg.9;
        Sat, 01 Apr 2023 05:52:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680353557;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=VBis5QrLUANy/l4geKyouqDW7rHm0E9crfbtdXx3L1Y=;
        b=nkQzqi7GYYsC6Wwi3wGZq83AwoKNq38MXY77cv2Iaz9hpR4s+yTBdK4bUkJ3cDzhJ+
         uKc/JlwN3upRzErB+z6wywzu53qqzUE0OVTp0WTgfuImI7qaRb4Htd5KSVCrrVrp6PWj
         iVYNBA91c8HWSjZre9NEDuSzQT2SwjubOIjkSvMnqo6KSpdpynwDEvTTasA6Rs8VTntr
         u3A3V/28F6nbJ5FgdvyijCA0Di78sMlqkZ7ZGheDAAVB2acTpwC9LG208+/Ai5X7D6Z+
         C7IaRjeDMoeHMKDMjn8VP0IfaBWGJHubsV4eHa996u0qZhGwkb57uuIwKGECqdKZd8gP
         x7Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680353557;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VBis5QrLUANy/l4geKyouqDW7rHm0E9crfbtdXx3L1Y=;
        b=LsBaX8+w+Ld65AUNT0GdWXeLB1IVVnMnEXjVkTAcpgUHDB0F6uivo0s6/6BU7w/iJd
         l4Zk6Yi1vddoW9KLFQmW94mjcz53bqoSnOxN03TV2YUcsTl8cE1rzY1+C97eQMcgdPwS
         kyCY0a6zoj5DuXCOAsBjp+ElTz5VRsgyPpfJ/vkTZ8pEEgQLtNImPce/B/wyHGrA95nH
         1T9KiclEeWQOmcTgdQI32HiWdwqzCAgsYPuzcDABnvuRirOR7XlJfajw/SLelfDpfSiX
         51QmFZGTr1sd0yy9gOSm8oqv+HBr4K1fCfZgL7S9oVJSK8vdnGXkLa9ZrKZhnYKxD1Mh
         KwIw==
X-Gm-Message-State: AAQBX9cJz4iYR3+89kaD7nU5wTxWAG9nqjnHrVWubZgRuyZXWsXi9oIm
        Vkr4IYaiyI9PDceJk1PEtnvv9sJhuLp9FoKg1Sk=
X-Google-Smtp-Source: AKy350aBQ5Viilm205H/7PeNtR7j7Q+xbUSlXoxw/09oXNtPLyPgTt3SEFFynepL2rYf3kMc4Lxso5YVyTNfuTumRC8=
X-Received: by 2002:a17:903:228a:b0:1a2:1674:3902 with SMTP id
 b10-20020a170903228a00b001a216743902mr11113845plh.10.1680353557086; Sat, 01
 Apr 2023 05:52:37 -0700 (PDT)
MIME-Version: 1.0
References: <m2fs9lgndw.fsf@gmail.com> <20230331194249.GA3247600@bhelgaas>
In-Reply-To: <20230331194249.GA3247600@bhelgaas>
From:   Donald Hunter <donald.hunter@gmail.com>
Date:   Sat, 1 Apr 2023 13:52:25 +0100
Message-ID: <CAD4GDZwgOVn4dR2qiqrQWz-fw52aT9uyv22NCdo+hY4HJEgofQ@mail.gmail.com>
Subject: Re: [BUG] net, pci: 6.3-rc1-4 hangs during boot on PowerEdge R620
 with igb
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Rob Herring <robh@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 Mar 2023 at 20:42, Bjorn Helgaas <helgaas@kernel.org> wrote:
>
> I assume this igb NIC (07:00.0) must be built-in (not a plug-in card)
> because it apparently has an ACPI firmware node, and there's something
> we don't expect about its status?

Yes they are built-in, to my knowledge.

> Hopefully Rob will look at this.  If I were looking, I would be
> interested in acpidump to see what's in the DSDT.

I can get an acpidump. Is there a preferred way to share the files, or just
an email attachment?

> Bjorn

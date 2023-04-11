Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 656546DDB44
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 14:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbjDKMxj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 08:53:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbjDKMxf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 08:53:35 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F0A040C1;
        Tue, 11 Apr 2023 05:53:34 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id eo6-20020a05600c82c600b003ee5157346cso5964415wmb.1;
        Tue, 11 Apr 2023 05:53:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681217612;
        h=mime-version:user-agent:references:message-id:date:in-reply-to
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=x9yZ+qnUfIedOP16sqw/n0wk0WAmpKQ2BM/zcb4X7c8=;
        b=FEqA8zIiXQo1JgRyGbmoTOBWasmNdOU1p+Jfx1mKzePVIJFwbUh2gS+SovCjj/P4kl
         s6cCpRy1rpNR2BAh4DuFEjOHp8djEDmwZcdRHT2Lflkyk4cyJy6XiTpV0tkaoXK5ff0a
         36l9wP0yEWdbvCIo40oHD5T4wlvvE5PvOnjnGJ5e6NBQ4I5Pd6TX0BFAjmZApNZ9iBAi
         cI0OU+VfjFdzAs4CPulzv8nH9I08XufU2Pzb28571Z5LZQlhdAkqODCDKgizenk+R8SI
         4/G26CpbXtT+PKcKn5XvUHhSq4nu/2VtgavErMGMWGjWr9PeoZSMVaPsrqH2lMhsnIoc
         pviQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681217612;
        h=mime-version:user-agent:references:message-id:date:in-reply-to
         :subject:cc:to:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x9yZ+qnUfIedOP16sqw/n0wk0WAmpKQ2BM/zcb4X7c8=;
        b=pue33kXH5fDJzzMw2Jt46BK80PM0UWrkxXBCoQPHymYR/VDDH+NCnCf9Vy/wFPpAVm
         ordbqU/FD/2IVWGlZaUVqm5T4WkoLMPwHAunnnK25Twn9KP8YwVee2wZ6qUkk4cGz6SG
         QFx8I+9TFH71lo59O0cZgfqmqsppcLgzru3qsgsHldmTAQuAaV4DtnABg0vqSRmnYLQz
         Xh+AnaxkoGQP2mGn4l8empDz0LOACQZFTbMLJBfK7torTxluXWoyZEts9cxVuf/HRwOU
         8wjrKDOyDrxOQBDoUAGQ9XG2D0yZeoFzkQvrjpgH22t3K+zwF7swPnSknuYBceFHdD1O
         F0TQ==
X-Gm-Message-State: AAQBX9fu3quuEBzkP695WRE1WKQQ73rmw784cS//Er2BsBqXFcbWpNv9
        UGs0IE5b4ZEFLIr9ax3JA5Y=
X-Google-Smtp-Source: AKy350a7/C5fkIWINCl0pxOpgu8uM2Qbd7glWkBEvzl1kM7rMBd1tJS81vJ1qW3TfQDn6oEnlllD8g==
X-Received: by 2002:a7b:ce16:0:b0:3ee:2b04:e028 with SMTP id m22-20020a7bce16000000b003ee2b04e028mr9178810wmc.14.1681217612343;
        Tue, 11 Apr 2023 05:53:32 -0700 (PDT)
Received: from imac ([88.97.103.74])
        by smtp.gmail.com with ESMTPSA id n23-20020a7bcbd7000000b003e20cf0408esm16924764wmi.40.2023.04.11.05.53.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 05:53:31 -0700 (PDT)
From:   Donald Hunter <donald.hunter@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Rob Herring <robh@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: Re: [BUG] net, pci: 6.3-rc1-4 hangs during boot on PowerEdge R620
 with igb
In-Reply-To: <20230410213754.GA4064490@bhelgaas> (Bjorn Helgaas's message of
        "Mon, 10 Apr 2023 16:37:54 -0500")
Date:   Tue, 11 Apr 2023 13:53:09 +0100
Message-ID: <m27cuih96y.fsf@gmail.com>
References: <20230410213754.GA4064490@bhelgaas>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bjorn Helgaas <helgaas@kernel.org> writes:

> On Mon, Apr 10, 2023 at 04:10:54PM +0100, Donald Hunter wrote:
>> On Sun, 2 Apr 2023 at 23:55, Bjorn Helgaas <helgaas@kernel.org> wrote:
>> > On Sat, Apr 01, 2023 at 01:52:25PM +0100, Donald Hunter wrote:
>> > > On Fri, 31 Mar 2023 at 20:42, Bjorn Helgaas <helgaas@kernel.org> wrote:
>> > > >
>> > > > I assume this igb NIC (07:00.0) must be built-in (not a plug-in card)
>> > > > because it apparently has an ACPI firmware node, and there's something
>> > > > we don't expect about its status?
>> > >
>> > > Yes they are built-in, to my knowledge.
>> > >
>> > > > Hopefully Rob will look at this.  If I were looking, I would be
>> > > > interested in acpidump to see what's in the DSDT.
>> > >
>> > > I can get an acpidump. Is there a preferred way to share the files, or just
>> > > an email attachment?
>> >
>> > I think by default acpidump produces ASCII that can be directly
>> > included in email.  http://vger.kernel.org/majordomo-info.html says
>> > 100K is the limit for vger mailing lists.  Or you could open a report
>> > at https://bugzilla.kernel.org and attach it there, maybe along with a
>> > complete dmesg log and "sudo lspci -vv" output.
>> 
>> Apologies for the delay, I was unable to access the machine while travelling.
>> 
>> https://bugzilla.kernel.org/show_bug.cgi?id=217317
>
> Thanks for that!  Can you boot a kernel with 6fffbc7ae137 reverted
> with this in the kernel parameters:
>
>   dyndbg="file drivers/acpi/* +p"
>
> and collect the entire dmesg log?

Added to the bugzilla report.

Thanks!

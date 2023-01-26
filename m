Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4680267D090
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 16:45:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232096AbjAZPpm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 10:45:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231604AbjAZPpl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 10:45:41 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CAD16BBFD
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 07:45:27 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id e15so2427890ybn.10
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 07:45:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UPITCMkn4MIcSbZJSsggqn6blM7WoJ+GUuovoHemy5c=;
        b=VB8W0SRgK3+voHF6mHKEQ6uCFETkrBtL1HSwhCx/OIeU4kLuQsWiXdYT6V/UmrGfHr
         8IT5TeqrYTVIWPIfL7RP0pU7xZTnAmptiF86Ox3HkXxw4f5WOZNrx1qGJuACEgFfpQIv
         b3ZwSw48mTEax/vwgwW+nD34z+IUpZRBoEa4pqNDIoikoj4RxY5wo+oCKr1FS6KrkkT6
         OSIUuxIsuJfejasd4gLye2TYQmBdWKvQZFiT9/SfUlfI2NDxSeTpmfNPFOZFqYp0NBpI
         Aa2nWn9StepkOEBRatVkRF9DvaYSDUWbI6gotG8ZNk/4cJQKJKaGa7xEgDEnXGTlcpu8
         5mlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UPITCMkn4MIcSbZJSsggqn6blM7WoJ+GUuovoHemy5c=;
        b=yXM2ReDVcfLu+caMwMVGNIRefXhExdILCGK4wMby7Bs1/SUZAx7fV989ZfpfuwbeqB
         kytm0nT1sPM7iiYh55NI8JQoADm4FV9rJxY5WzToULY30TA1crUrdb2+jwGkL2ATxO06
         Z77Z5F6lf7NkQf1AyvMfGBVw6UkvXSZDusY/gVWGd3eaUVyqpoDKP273uz8p4p6b27aa
         A0yijg7PSjoRzMzVUMDMDFq+pnSKCDrwhOSSCjtusHCHJYET8om1vsprtF1aFjv8mqdP
         RJvgTkpUiusiI3NvmuIQS+S14u9IftedeGWH702MYWoLOmWQHRAh48HPp2FahTEdvxkO
         SyxA==
X-Gm-Message-State: AO0yUKVDFx+V+6icJA/xg9yYDH04ERDQ8Fn5FPRVExL+2d92fYXu9If7
        EdNDUlYicLHdi/LAGP7wmwGWeB0YahgSKDIk/iuiEQ==
X-Google-Smtp-Source: AK7set+IRCYArYwTbmCo2pORwQhC4IhaK/gvTlIfVqaVSI937PydUfJIaFUXKOpMFtk/7KXXPBRtkLXymXCRtvn97A8=
X-Received: by 2002:a25:ab74:0:b0:80b:5572:33f3 with SMTP id
 u107-20020a25ab74000000b0080b557233f3mr1496441ybi.199.1674747926336; Thu, 26
 Jan 2023 07:45:26 -0800 (PST)
MIME-Version: 1.0
References: <20230124170510.316970-1-jhs@mojatatu.com> <20230124170510.316970-17-jhs@mojatatu.com>
 <87bkmmcnoj.fsf@nvidia.com>
In-Reply-To: <87bkmmcnoj.fsf@nvidia.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Thu, 26 Jan 2023 10:45:15 -0500
Message-ID: <CAM0EoM=_KWL23RdGjESX_Mqxa97nXWZX_T1YdtSkeNmszDVfSg@mail.gmail.com>
Subject: Re: [PATCH net-next RFC 17/20] p4tc: add table entry create, update,
 get, delete, flush and dump
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com,
        deb.chatterjee@intel.com, anjali.singhai@intel.com,
        namrata.limaye@intel.com, khalidm@nvidia.com, tom@sipanda.io,
        pratyush@sipanda.io, jiri@resnulli.us, xiyou.wangcong@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, simon.horman@corigine.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 25, 2023 at 4:25 PM Vlad Buslov <vladbu@nvidia.com> wrote:
>
> On Tue 24 Jan 2023 at 12:05, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> > +     int                              num_acts;
> > +     struct rhlist_head               ht_node;
> > +     struct list_head                 list;

[..]

> > +static int __tcf_table_entry_del(struct p4tc_pipeline *pipeline,
> > +                              struct p4tc_table *table,
> > +                              struct p4tc_table_entry_key *key,
> > +                              struct p4tc_table_entry_mask *mask, u32 prio,
> > +                              struct netlink_ext_ack *extack)
>
> This seems to be an infrastructure function implemented for future
> usage, but since it is static and not called form anywhere it causes
> compilation failure on this and following patches.
>

Ah - you must be compiling with -Werror.
There's some other code we didnt include for statefulness (what they
call "add on miss" in P4 PNA)
that would use this. We should have taken this out. We will take it
out in the next update if add-on-miss is
not included.

> > +{
> > +     struct p4tc_table_entry *entry;
> > +     int ret;
> > +
> > +     tcf_table_entry_build_key(key, mask);
> > +
> > +     entry = p4tc_entry_lookup(table, key, prio);
> > +     if (!entry) {
> > +             rcu_read_unlock();
>
> Where is the dual rcu_read_lock() for this?
>

Shouldnt be there at all. Speaks to the state of completion for add-on-miss
which is still in process of being implemented to meet the spec.

BTW:  I apologize if i skipped some of your comments - i am having a bit of a
hard time with a web based agent (I am giving up on thunderbird since it cant
seem to handle well the amount of emails i have using IMAP).
So if i skipped something it is not intentional, just point it out
again. I am using
old skule hand editing of the email when responding.

cheers,
jamal

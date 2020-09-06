Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF94625ED9F
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 13:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728662AbgIFLQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Sep 2020 07:16:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725803AbgIFLQT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Sep 2020 07:16:19 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CCF0C061573
        for <netdev@vger.kernel.org>; Sun,  6 Sep 2020 04:16:14 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id y4so12810188ljk.8
        for <netdev@vger.kernel.org>; Sun, 06 Sep 2020 04:16:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qvW+A+bjM8Jy9NqOGqt96gnTvYKu8GGTNTdz8X2hcy8=;
        b=LmXKbBpoclvr94CWX2JSALrAIi0vns+/Ry8hnEeZn5uzOZ8AfQvr+V+ay5Bc6M0nuR
         IrhjjxYP0OFs86el1CXoOUOWBfJQVwxrY1d7eJ6U8T0bMqvHTPytWQYk4O3ZKXajpWYV
         6znRhUm9W92WkkQqXoWdg6AwbfqHCwLe8mrkc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qvW+A+bjM8Jy9NqOGqt96gnTvYKu8GGTNTdz8X2hcy8=;
        b=uUp1xORF4s7IWBkz1gESflZPjHRT+geypyl9nunsa2IGItjugKBXlt1ps/7gNl436t
         xQmz1+32xscmPqAWMH6VptsdIMHF1MTjs+/Sfz8H7JCEyhPPHm44n3vWX8lwD3cZvG2L
         bcLa807b5QcIP/mN3jSbHZxMrXerdMmiiLJVCAxNa5r84jVZP8f6bRe53P8a6L9Cu4Wn
         foZHxq6yzptgKulXGncTJPrdwSEPcqE5h7FaiDNZmkX7Qn8RX5z2RYVnOGcg2lMR4k+9
         z2DoedSGpgKk8oqloYAHFSJPP4AGG/ROLhVZiiaEj5mtGoyoFfjLD/g3qbWbDgbGmeHO
         ycLw==
X-Gm-Message-State: AOAM532pcKBkHj/Y05bjnE2EukXP9wpgdJhPkvcs3IMTasLnzky5D+Ii
        TDBL9xEY9GwDImXxW7SyuO5LP/B7nZwZCR4SCFORlA==
X-Google-Smtp-Source: ABdhPJwwQ8GLtZaFeofiyNDDeemyrhN+fvV5bGPkIVmxUY5lbOBFxx0qUxMqwk2Q6LlntwDn9t2jZMuqGCmHUCaW+3Q=
X-Received: by 2002:a2e:7010:: with SMTP id l16mr7569488ljc.38.1599390969047;
 Sun, 06 Sep 2020 04:16:09 -0700 (PDT)
MIME-Version: 1.0
References: <CAACQVJo_n+PsHd2wBVrAAQZm9On89TcEQ5TAn7ZpZ1SNWU0exg@mail.gmail.com>
 <20200903121428.4f86ef1f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200903121428.4f86ef1f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Date:   Sun, 6 Sep 2020 16:45:57 +0530
Message-ID: <CAACQVJqjrBqVqdZN6cnFOSXmVs6vdsrVzOeMd-4aG--NgoLn8g@mail.gmail.com>
Subject: Re: Failing to attach bond(created with two interfaces from different
 NICs) to a bridge
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jiri Pirko <jiri@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>, jtoppins@redhat.com,
        Netdev <netdev@vger.kernel.org>,
        Ido Schimmel <idosch@idosch.org>, Andrew Lunn <andrew@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 4, 2020 at 12:44 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 3 Sep 2020 12:52:25 +0530 Vasundhara Volam wrote:
> > Hello Jiri,
> >
> > After the following set of upstream commits, the user fails to attach
> > a bond to the bridge, if the user creates the bond with two interfaces
> > from different bnxt_en NICs. Previously bnxt_en driver does not
> > advertise the switch_id for legacy mode as part of
> > ndo_get_port_parent_id cb but with the following patches, switch_id is
> > returned even in legacy mode which is causing the failure.
> >
> > ---------------
> > 7e1146e8c10c00f859843817da8ecc5d902ea409 net: devlink: introduce
> > devlink_compat_switch_id_get() helper
> > 6605a226781eb1224c2dcf974a39eea11862b864 bnxt: pass switch ID through
> > devlink_port_attrs_set()
> > 56d9f4e8f70e6f47ad4da7640753cf95ae51a356 bnxt: remove
> > ndo_get_port_parent_id implementation for physical ports
> > ----------------
> >
> > As there is a plan to get rid of ndo_get_port_parent_id in future, I
> > think there is a need to fix devlink_compat_switch_id_get() to return
> > the switch_id only when device is in SWITCHDEV mode and this effects
> > all the NICs.
> >
> > Please let me know your thoughts. Thank you.
>
> I'm not Jiri, but I'd think that hiding switch_id from devices should
> not be the solution here. Especially that no NICs offload bridging
> today.
>
> Could you describe the team/bridge failure in detail, I'm not that
> familiar with this code.

I am copying the Redhat kernel team analysis in crisp to clarify. Hope
this helps.

----
When a new bridge port is being set up in br_add_if(),
nbp_switchdev_mark_set() is called to get the Switch ID of the new
port (in this case, the bond). Prior to devlink_compat_switch_id()
changes, the bond's lower devs (the bnxt ports) do not report a Switch
ID (EOPNOTSUPP) when device is not in SWITCHDEV mode, so this activity
is moot.

Prior to the devlink_compat_switch_id() changes,
switchdev_port_attr_get() is set and points to
bnxt_swdev_port_attr_get(). It simply calls bnxt_port_attr_get():

8358 static const struct switchdev_ops bnxt_switchdev_ops = {
8359         .switchdev_port_attr_get        = bnxt_swdev_port_attr_get
8360 };

8352 static int bnxt_swdev_port_attr_get(struct net_device *dev,
8353                                     struct switchdev_attr *attr)
8354 {
8355         return bnxt_port_attr_get(netdev_priv(dev), attr);
8356 }

- Basically, bnxt_port_attr_get() is either going to copy the switch
ID into the passed-in switchdev_attr struct OR return -EOPNOTSUPP for
legacy mode:

8332 int bnxt_port_attr_get(struct bnxt *bp, struct switchdev_attr *attr)
8333 {
8334         if (bp->eswitch_mode != DEVLINK_ESWITCH_MODE_SWITCHDEV)
8335                 return -EOPNOTSUPP;
8336
8337         /* The PF and it's VF-reps only support the switchdev framework */
8338         if (!BNXT_PF(bp))
8339                 return -EOPNOTSUPP;
8340
8341         switch (attr->id) {
8342         case SWITCHDEV_ATTR_ID_PORT_PARENT_ID:
8343                 attr->u.ppid.id_len = sizeof(bp->switch_id);
8344                 memcpy(attr->u.ppid.id, bp->switch_id,
attr->u.ppid.id_len);
8345                 break;
8346         default:
8347                 return -EOPNOTSUPP;
8348         }
8349         return 0;
8350 }


However, now the bnxt driver provides an ID via its new
ndo_get_devlink_port() handler. Logic in dev_get_port_parent_id()
returns ENODATA if the bond's ports do not all have the same switch
identifier (here, phys_switch_id).

Now nbp_switchdev_mark_set() only uses dev_get_port_parent_id(), which
calls devlink_compat_switch_id_get and when it comes to the bnxt
devices the call to devlink_compat_switch_id_get() actually returns a
useful value. But of course, the Switch ID of two physically separate
cards is not expected to be the same so the overall result is the
ENODATA and the bond is failed to attach to the bridge..
---------

I am typing the above and saw mail from Ido Schimmel in parallel.

Thanks,
Vasundhara

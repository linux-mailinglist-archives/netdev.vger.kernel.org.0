Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF365D92D
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 02:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727138AbfGCAgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 20:36:18 -0400
Received: from mail-qk1-f171.google.com ([209.85.222.171]:39326 "EHLO
        mail-qk1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727072AbfGCAgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 20:36:18 -0400
Received: by mail-qk1-f171.google.com with SMTP id i125so400946qkd.6
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 17:36:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=CO/zkcBTjGj/Gk7ldnLr/giPGw3ebAPAi0AoWNxKN14=;
        b=iAe0fDD2GjdbVBEEajN/7v4xcF+apwCIdhlHmAPfp32G46Eimj8j/r3yj0R+GSmT27
         DEsDTz7TQTzHuOTF79TPQJhhLElo8jWRz5nWd09WjiFGu38UwH6OS8GHllZywNbt8DaU
         6htWRIMwclPk11epzSccu8fWGLc/D+0Qe2qzE1hL+Mz8j5ZEgv3Gg+NHvhlscWDhULuc
         dBFbrrR4qzB04lu1khDxRLinghRaP4enJrqO/wt46AkLyt/bUcl0Frd65DSaVX0DAoTi
         0NVl+pNmkGg/ImfroA1uGP2SvXJOYqdxWb7xifIPLTqJxhZOJ0AtZi/oSn1mdVP4CUE3
         n7BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=CO/zkcBTjGj/Gk7ldnLr/giPGw3ebAPAi0AoWNxKN14=;
        b=jSg0CO81eafXRBwfVFq4jkssQ2B1sDBbL9u19iVXpV3Bzks+1rlo8IRbhBZmXKfTtn
         vtc2PeIEpQK5cfz9J4HEp0z3yBylsFgcjkG8vfXkGO4nwsQ7bAC3JdCjFZfV4agXyM5n
         3O2k/X/OtMR+dnNzVF3elv+zLnWtfs9zbfuNYyknbsRZZpB1t78SDO+XeHLXZJgHcjSw
         2mHWgLGR8Rtk39RhTQsw3AXgcD7W6N9FoNyJ3sQcOYXQtfFri/3aVjFNkDyM6k8NEuYb
         ckZD8jOJJoT0FfkzpNj5fEGCnFu/yGnuMeBnUPeHaMKYpIIV2zdf+MHxIta+mGnwwFXW
         ILug==
X-Gm-Message-State: APjAAAW2sq4oCe6HCsoaO44kbUss7toO6UeFonpgcMg/jWIeya4vGh5m
        3XVAAHDu/b5mX3MUVuvOcKPQXj1lIOE=
X-Google-Smtp-Source: APXvYqyOOTWQktUNqY+v5vSmWgwE1pjmNiVDRezZZGQA87U7hS/rNXdtBhG/UVHlhp4IhyFmAmNjIA==
X-Received: by 2002:a37:895:: with SMTP id 143mr28218801qki.38.1562110978022;
        Tue, 02 Jul 2019 16:42:58 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id j8sm149305qki.85.2019.07.02.16.42.57
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 02 Jul 2019 16:42:57 -0700 (PDT)
Date:   Tue, 2 Jul 2019 16:42:52 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     Jiri Pirko <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: [PATCH net-next 1/3] devlink: Introduce PCI PF port flavour and
 port attribute
Message-ID: <20190702164252.6d4fe5e3@cakuba.netronome.com>
In-Reply-To: <AM0PR05MB4866C19C9E6ED767A44C3064D1F80@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190701122734.18770-1-parav@mellanox.com>
        <20190701122734.18770-2-parav@mellanox.com>
        <20190701162650.17854185@cakuba.netronome.com>
        <AM0PR05MB4866085BC8B082EFD5B59DD2D1F80@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190702104711.77618f6a@cakuba.netronome.com>
        <AM0PR05MB4866C19C9E6ED767A44C3064D1F80@AM0PR05MB4866.eurprd05.prod.outlook.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2 Jul 2019 18:50:31 +0000, Parav Pandit wrote:
> > > I didn't see any immediate need to report, at the same time didn't
> > > find any reason to treat such port flavours differently than existing
> > > one. It just gives a clear view of the device's eswitch. Might find it
> > > useful during debugging while inspecting device internal tables..  
> > 
> > PFs and VFs ports are not tied to network ports in switchdev mode.
> > You have only one network port under a devlink instance AFAIR, anyway.
> >   
> I am not sure what do you mean by network port.

DEVLINK_PORT_FLAVOUR_PHYSICAL

> Do you intent to see a physical port that connects to physical network?
> 
> As I described in the comment of the PF and VF flavour, it is an eswitch port.
> I have shown the diagram also of the eswitch in the cover letter.
> Port_number doesn't have to a physical port. Flavour describe what
> port type is and number says what is the eswitch port number.
> Hope it clarifies.

I understand what you're doing.  If you want to expose some device
specific eswitch port ID please add a new attribute for that.
The fact that that ID may match port_number for your device today 
is coincidental.  port_number, and split attributes should not be
exposed for PCI ports.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FDB0FB98E
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 21:19:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbfKMUTy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 15:19:54 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:39192 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbfKMUTy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 15:19:54 -0500
Received: by mail-lf1-f67.google.com with SMTP id j14so3028457lfk.6
        for <netdev@vger.kernel.org>; Wed, 13 Nov 2019 12:19:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=L0YGjPYllNroXem9hdXDTEr2cEccVm9hYRd04QPBq2w=;
        b=tYZE4NXWq4zh3FxcMOA1TC/Ht3Az36NzFx1lgg/JQ3eHJOKaO9kIKGgtakLz/9fhnc
         FbmtX+VlmeGTRXjfMI9BRxnP871kQgDHviUoGr5VgpUDPKCYjliYitCPfJHoffwfMu/F
         6fFHFX6WL5aNzVZgEIZDE7+nJ52bRdGDvrGo7683rml7cCctSf64Og2cVJw8BEbhtTPo
         /VxFZmRuBsjYqCM2gw+PryH9cAEXDzrW0huYUa05tKugRtAhZNRucDUnC3Po6clSLgyA
         9b3KIM50Eh6n+7fVbxPpJN2qi/3He1VoKFT3oD7tYs0rB1cUwXcdvzgjSeByHEudUxhr
         v/KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=L0YGjPYllNroXem9hdXDTEr2cEccVm9hYRd04QPBq2w=;
        b=gD2DiwLHPVX/8olpfBYVM1TT0E9CPA3v6dMg2I07wrkmVlfxXffHBfNOnY/jHYfZ6G
         u6/Ta6uhI/J5OI1+ZokYEaK767OMNjWUsvWH/DO6R2rLVAxwUqQgbqKs8YH5o3fWJLL3
         xn7G2ehy/2BKQ9RkMKdtGw5XNvFcJ3wW7TLj4JA6sS6SnHSOlvr4C7OMPFS2FueD2vJv
         8/WhQ9hj3dpMAoQaiuxIn142OpOXSREqy/GF6/EAZAUDG5ck4RRDFoynD+/NfC5NFRjE
         NvLMfbwpHo1QuD4wEgOFIseMtExSlVKSxYHPuPHel9kzhHt1QlhY8q4iflzpcpplMLi2
         xvxw==
X-Gm-Message-State: APjAAAWZNNE2FyQViZ67sXSBfOYf58qneO+OaUwZBcDFWaz9B6yuD22T
        FPl1zxh/F017usCZ61xQFhJmYGJ9AYk=
X-Google-Smtp-Source: APXvYqxTaGLvlm4AYSDFtSl+mu2X5UMNCwGtikPMRANJnyK8Nm3NJyrCmIe+LMK5lEwIKNJp24CcuA==
X-Received: by 2002:ac2:52b3:: with SMTP id r19mr2887391lfm.109.1573676391988;
        Wed, 13 Nov 2019 12:19:51 -0800 (PST)
Received: from cakuba ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id p14sm1307171ljc.8.2019.11.13.12.19.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2019 12:19:51 -0800 (PST)
Date:   Wed, 13 Nov 2019 12:19:43 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Saeed Mahameed <saeedm@dev.mellanox.co.il>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ariel Levkovich <lariel@mellanox.com>
Subject: Re: [net-next 8/8] net/mlx5: Add vf ACL access via tc flower
Message-ID: <20191113121943.4df01958@cakuba>
In-Reply-To: <CALzJLG8ZiBdibjwY+xg0iBgqoEC1BFLcejTyHZYfsfbB7d20cQ@mail.gmail.com>
References: <20191112171313.7049-1-saeedm@mellanox.com>
        <20191112171313.7049-9-saeedm@mellanox.com>
        <20191112154124.4f0f38f9@cakuba>
        <CALzJLG8ZiBdibjwY+xg0iBgqoEC1BFLcejTyHZYfsfbB7d20cQ@mail.gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Nov 2019 16:31:19 -0800, Saeed Mahameed wrote:
> On Tue, Nov 12, 2019 at 3:41 PM Jakub Kicinski wrote:
> > On Tue, 12 Nov 2019 17:13:53 +0000, Saeed Mahameed wrote:  
> > > From: Ariel Levkovich <lariel@mellanox.com>
> > >
> > > Implementing vf ACL access via tc flower api to allow
> > > admins configure the allowed vlan ids on a vf interface.
> > >
> > > To add a vlan id to a vf's ingress/egress ACL table while
> > > in legacy sriov mode, the implementation intercepts tc flows
> > > created on the pf device where the flower matching keys include
> > > the vf's mac address as the src_mac (eswitch ingress) or the
> > > dst_mac (eswitch egress) while the action is accept.
> > >
> > > In such cases, the mlx5 driver interpets these flows as adding
> > > a vlan id to the vf's ingress/egress ACL table and updates
> > > the rules in that table using eswitch ACL configuration api
> > > that is introduced in a previous patch.  
> >
> > Nack, the magic interpretation of rules installed on the PF is a no go.  
> 
> PF is the eswitch manager it is legit for the PF to forward rules to
> the eswitch FDB,
> we do it all over the place, this is how ALL legacy ndos work, why
> this should be treated differently ?

It's not a legacy NDO, there's little precedent for it, and you're
inventing a new meaning for an operation.

> Anyway just for the record, I don't think you are being fair here, you
> just come up with rules on the go just to block anything related to
> legacy mode.

I tried to block everything related to legacy NDOs for a while now, and
I'm not the only one (/me remembers Or in netdevconf 1.1). I'm sorry but
I won't go and dig out the links now, it's a waste of time.

Maybe we differ on the definition of fairness. I'm against this exactly
_because_ I'm fair, nobody gets a free pass, no matter how much we
otherwise appreciate given company contributing to the kernel...

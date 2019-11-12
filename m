Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07025F9E40
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 00:42:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbfKLXlc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 18:41:32 -0500
Received: from mail-lf1-f48.google.com ([209.85.167.48]:41788 "EHLO
        mail-lf1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726910AbfKLXlc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 18:41:32 -0500
Received: by mail-lf1-f48.google.com with SMTP id j14so305613lfb.8
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 15:41:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=hXmMw43KilkUpSSBInBWICHDxaPycQ9xcDK3utxHrfY=;
        b=jH7rmuInzK4e16AK/y/pviMv8gBym1uGgmvW6JRtEs5OSJ2/USCMmmLKqfUV42DZZC
         WSEGNBWaIrUPmdcsO65UC+eVjF4dA2oesHP+LmSXGEuFGgGuKfVa1DWDO0Ii0Dxfg4sQ
         Gj499lyGUahrrn52fRylGWrRdOweCALwvk0xadMeKYglHbEeOWdPc1ucUSNbevJcxpUC
         Weg7ipnIa3kmJ5LKL9dTKK7cQfenaf1VogcVvfWrDrK9x4sz3jk3uiLe3pmNiWe+LRYE
         2lEUZwhdFSn71//+GtI1kI1kJ8dDJAMjNPa+3u2HmZ7W70FluKnSiGJNQMuIsDQXOT8L
         7Vlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=hXmMw43KilkUpSSBInBWICHDxaPycQ9xcDK3utxHrfY=;
        b=XJrgj7msYUEpwSuuU7WbK8XIp035wKh0arjbcL5EGWUh8pNIA0NgZaOKWoNpZWvVyU
         TY9SKEE8HQAmoQpBZsZAXLPNJrcfRsaSbJaZgci3/26Flx7mPVBif3H2wuUG3PaEJupr
         a0S4bFgv8CPlejNiAnZeYQac9tYiPxaZH/AeSZ7R4I5H5GgGNq85Ibzt/CZRW/y4x5pR
         17KWnYoaNPEe+wz6xprt87QjppukyDHmEHiaGOahywEXtlQDCpRp2NWx9R6a+koatW24
         oQ4HHg7L0kxtpOi1ajRu8R1VZIvFRp3BU5uUS476/y7nuZGwwvKkMZCyRnRqeQwAqSoq
         BlUg==
X-Gm-Message-State: APjAAAXEwXIpJgfgJ8VT+J44HFuV1RTXv+lOQSyPfIEXm0Obb1u2WPdI
        8ra3vgRyD8JBYbzgoF7LtE7ERQ==
X-Google-Smtp-Source: APXvYqwwj2CBf9o8hp2qKlP1yUk0z8cMZKwl/nI8Lg7QcD4UGuPzJscvx8B5Emi1ibD5qvAepUKfQA==
X-Received: by 2002:a19:ee1a:: with SMTP id g26mr331532lfb.0.1573602090337;
        Tue, 12 Nov 2019 15:41:30 -0800 (PST)
Received: from cakuba ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id t14sm86190ljj.4.2019.11.12.15.41.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2019 15:41:30 -0800 (PST)
Date:   Tue, 12 Nov 2019 15:41:24 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ariel Levkovich <lariel@mellanox.com>
Subject: Re: [net-next 8/8] net/mlx5: Add vf ACL access via tc flower
Message-ID: <20191112154124.4f0f38f9@cakuba>
In-Reply-To: <20191112171313.7049-9-saeedm@mellanox.com>
References: <20191112171313.7049-1-saeedm@mellanox.com>
        <20191112171313.7049-9-saeedm@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Nov 2019 17:13:53 +0000, Saeed Mahameed wrote:
> From: Ariel Levkovich <lariel@mellanox.com>
> 
> Implementing vf ACL access via tc flower api to allow
> admins configure the allowed vlan ids on a vf interface.
> 
> To add a vlan id to a vf's ingress/egress ACL table while
> in legacy sriov mode, the implementation intercepts tc flows
> created on the pf device where the flower matching keys include
> the vf's mac address as the src_mac (eswitch ingress) or the
> dst_mac (eswitch egress) while the action is accept.
> 
> In such cases, the mlx5 driver interpets these flows as adding
> a vlan id to the vf's ingress/egress ACL table and updates
> the rules in that table using eswitch ACL configuration api
> that is introduced in a previous patch.

Nack, the magic interpretation of rules installed on the PF is a no go.

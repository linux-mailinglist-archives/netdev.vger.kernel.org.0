Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7E3C5DC5C
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 04:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727828AbfGCCWW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 22:22:22 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:44332 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727663AbfGCCPm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 22:15:42 -0400
Received: by mail-qk1-f195.google.com with SMTP id p144so604311qke.11
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 19:15:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=leu2Z7lZQLubhQ6t1284nOghnTElOtB44m4CQPkjFxQ=;
        b=oa3fZ3ygrR3MY3w/gVIBWkUIzgoXw8v00xIGHsLde/Erucmsx0IG9zYhVXNxnOhQv5
         E/809stHnTGkXQ3Ay/IP0GIjPzfiRu8a+Lu7yzdIHfykqLwFjIoL2CKDomrGwpWE5uoi
         0QinTE5fNT4Pf2N9o31DwzDCH/MZa0I2WEbPX8dT5sZ0BwFWjpXkyBREnqY139WHxQdV
         mV48WqJRovjwpGUgEZ1GD4ZJklIl64OLeA/3LSRQ7o2fCDsvg+N6j6ZrKtj9cRvO3vQf
         WFIAEEH7SDEGBc3vCjEMDjAviPkfZnBHRPetMibIN8Gp0b2+vyHxjf757CXYBYwh2J8k
         BQUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=leu2Z7lZQLubhQ6t1284nOghnTElOtB44m4CQPkjFxQ=;
        b=LI5Tw84mmjDFjClaCzeJ1a4J8/nesZ5t9nBbhtAjvBFhUGzva5xNx1x7U3r2EGqiP7
         l39zSkzpbjRcpE6+kYs2tujRn7YOxKQzZFSYowqeHNArUX8X9TWy2MHbWM7zad5YDEwe
         t0QThRL/vUax5e8rgNcrlYJ3sYN+x06avEsu+IK36d4MhuV37qB+vcLEkuszzEEdc5Ca
         NwtOkuHaLZrt//bXiziiNc0QcBMzDhCUW7MsOJ7BQCuoeU0HdVLHgB2F5m+H48nRHp70
         EjPWU5jNjTO6pfLpulGtC/P8qzBQtC4MV7UImnctyll/Z2u1LjZ8PSKaKGstysNGT4ig
         ORiQ==
X-Gm-Message-State: APjAAAU7ngwdrLLwf/a/Jhp3Zll1QTha8uC5HSCketBVfDJ5zoPivZE1
        F3WyIG4QURkTPhZQozuDWuTpMQ==
X-Google-Smtp-Source: APXvYqw3JihPwXL4EeG6NBmta3hdu4hoF2PLLZp1dotp37tQucIDZIOEBEbufO0nZtCC5XOqOzn2lg==
X-Received: by 2002:a37:a98c:: with SMTP id s134mr28012734qke.176.1562120141404;
        Tue, 02 Jul 2019 19:15:41 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id o21sm328283qtq.16.2019.07.02.19.15.40
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 02 Jul 2019 19:15:41 -0700 (PDT)
Date:   Tue, 2 Jul 2019 19:15:36 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     Jiri Pirko <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: [PATCH net-next 1/3] devlink: Introduce PCI PF port flavour and
 port attribute
Message-ID: <20190702191536.4de1ac68@cakuba.netronome.com>
In-Reply-To: <AM0PR05MB4866F1AF0CF5914B372F0BCCD1FB0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190701122734.18770-1-parav@mellanox.com>
        <20190701122734.18770-2-parav@mellanox.com>
        <20190701162650.17854185@cakuba.netronome.com>
        <AM0PR05MB4866085BC8B082EFD5B59DD2D1F80@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190702104711.77618f6a@cakuba.netronome.com>
        <AM0PR05MB4866C19C9E6ED767A44C3064D1F80@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190702164252.6d4fe5e3@cakuba.netronome.com>
        <AM0PR05MB4866F1AF0CF5914B372F0BCCD1FB0@AM0PR05MB4866.eurprd05.prod.outlook.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 3 Jul 2019 02:08:39 +0000, Parav Pandit wrote:
> > If you want to expose some device specific
> > eswitch port ID please add a new attribute for that.
> > The fact that that ID may match port_number for your device today is
> > coincidental.  port_number, and split attributes should not be exposed for
> > PCI ports.
>
> So your concern is non mellanox hw has eswitch but there may not be a
> unique handle to identify a eswitch port?

That's not a concern, no.  Like any debug attribute it should be
optional.

> Or that handle may be wider than 32-bit?

64 bit would probably be better, yes, although that wasn't my initial
concern.

> And instead of treating port_number as handle, there should be
> different attribute, is that the ask?

Yes, the ask, as always, is to not abuse existing attributes to carry
tangentially related information.

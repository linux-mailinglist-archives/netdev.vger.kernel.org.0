Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7FE048CE8E
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 23:54:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234580AbiALWyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 17:54:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234627AbiALWyK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 17:54:10 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A92AC06173F;
        Wed, 12 Jan 2022 14:54:10 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id l25so6820321wrb.13;
        Wed, 12 Jan 2022 14:54:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LTP+F/Ok0PRG+GrIl3YGT9PiDnX7zo2FYTETEB0XL/U=;
        b=gE8XFAIa9tPLz5Ntct+FROhxffLQustae0w53TU3FmEn1We3L8Y4FisLrGYL/7hbxj
         KTV3aYXUpbrKpbq2+OT8p7eaqYgyHlhkJSoNoOfCE8CBg2ENFHm963Ke99O/QsRuUEF2
         s5Lj4bkR7eSvuXXFgtm6iNvcKyIgyC3dpPwWEPDoeyyfE0YrgZraOWCki7zXp3tL4qxt
         YTg14QfaHChmoahDG3sQ/YvTZE8aymyM9FxmhN07EKGUf3dVx605s3jk3Xnl7CZQJEoB
         02kfv3NqxrvWIPXGfUgeNlIYUhkHSRU5YtqU0UPS2nwI/bIKfRg6XMKFktkNpPk60gUy
         hamg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LTP+F/Ok0PRG+GrIl3YGT9PiDnX7zo2FYTETEB0XL/U=;
        b=5uwzvGdpbBotzLZgHkniRJUCIRajf7jhwpooCO0PwoQgciLwTk/J6fSs4V2Whi9LaF
         BTFmarU/FgYfsWpB7C/+2anKu6eLCx0Lj00gJBdBLkcIpe4A02cFwRn4z1QYVeb+GUA5
         ax35SlTJUfxMGMR7MMCV1DSDygde/YoqZhAhOBRmjf6tcVrVXBfxZ5brzfFAmds1pBZ2
         83NE+VfzKneo05qa3yf4Cm6C9YLK+uSgamFvXe1y8adb2RV2xx1xtNjg66KnjdMDf9jt
         4tymo9Qu9aJvrE/nDGXpdyFr6gV9X1t4TylWDkP3FttlfInCttzxl0CPNbFPYYBXwil5
         9Uxg==
X-Gm-Message-State: AOAM533HTbne7P9ZFz2LmOiqK4XXPI+GVh7meQQEftlokUi7LuTzAkGL
        eswpvLy0LIw103HXtraVfoYV2JiqyA/Mzm+5hy8=
X-Google-Smtp-Source: ABdhPJxsWFLaZjsJgELI9R2LezFhnLPBYFQxdWdcf3KvT8Vk6DsGmHubgN0JImVpBT7NGyWnzA6pvCC5t+xxaPDXhf0=
X-Received: by 2002:a05:6000:186e:: with SMTP id d14mr1596585wri.205.1642028048812;
 Wed, 12 Jan 2022 14:54:08 -0800 (PST)
MIME-Version: 1.0
References: <20220112173312.764660-1-miquel.raynal@bootlin.com>
 <20220112173312.764660-2-miquel.raynal@bootlin.com> <CAB_54W7uEQ5RJZxKT2qimoT=pbu8NsUhbZWZRWg+QjXDoTPFuQ@mail.gmail.com>
In-Reply-To: <CAB_54W7uEQ5RJZxKT2qimoT=pbu8NsUhbZWZRWg+QjXDoTPFuQ@mail.gmail.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Wed, 12 Jan 2022 17:53:57 -0500
Message-ID: <CAB_54W7OjmvF5UipMk8PYDKrYmcq-2sXBNHLRpbqM6+a0YQ_Fg@mail.gmail.com>
Subject: Re: [wpan-next v2 01/27] net: mac802154: Split the set channel hook implementation
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Harry Morris <h.morris@cascoda.com>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "linux-wireless@vger.kernel.org Wireless" 
        <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, 12 Jan 2022 at 17:30, Alexander Aring <alex.aring@gmail.com> wrote:
>
> Hi,
>
> On Wed, 12 Jan 2022 at 12:33, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> >
> > As it is currently designed, the set_channel() cfg802154 hook
> > implemented in the softMAC is doing a couple of checks before actually
> > performing the channel change. However, as we enhance the support for
> > automatically setting the symbol duration during channel changes, it
> > will also be needed to ensure that the corresponding channel as properly
> > be selected at probe time. In order to verify this, we will need to
>
> no, we don't set channels at probe time. We set the
> current_page/channel whatever the default is according to the hardware
> datasheet. I think this channel should be dropped and all drivers set

s/channel/patch/

- Alex

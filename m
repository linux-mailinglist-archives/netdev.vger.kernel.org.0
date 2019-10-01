Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5C99C3D6C
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 18:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730612AbfJAQ7n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 12:59:43 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:37064 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730615AbfJAQlG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 12:41:06 -0400
Received: by mail-pl1-f194.google.com with SMTP id u20so5746296plq.4
        for <netdev@vger.kernel.org>; Tue, 01 Oct 2019 09:41:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wWx6wd3DIiucF+Ocv7n1SU0Th5H7npNVE0zzmnuydhU=;
        b=UuQs43OhGgF0e0PCeN/p+BGim5fp57VfMnBxVRhLHeHO42C0dF3FiLIvy2P/KOoTop
         D8wFLFNqlGrIkdQTGbzrWDABccy9iD5K8LOaTOUgKaAeBnr2SjKd5LTOVEqG3ggy+Atd
         IpLG8/E2MXUJuuuCnoCpZpVBNKRXgxBHFYQzlWLH0dvMeyUh+lYw+gVrV1OH3F+sHD3R
         DEJAwubCF+2wV2Ux8GqaRKsQ3Vw46ZO5m2D1jQoWzGYX7TEeFiUE1sbWZo0jWQ0EWQz3
         YGLioif80xqj0BD66Og47ERRZL+RfZ/IrTZZQH1y6Jlvs2I7SmvOr88a99ydT3XDmT21
         BUGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wWx6wd3DIiucF+Ocv7n1SU0Th5H7npNVE0zzmnuydhU=;
        b=tHq6lIvjAL6GfYK9fSVes1UPkyhOw6VY+FWHQsteFEMKWndu+j+iooRdGB6zXEo1r1
         WHueAbl1txOdI6ehSj2Y8qgqxZrxILnRiHkhzVfCmKUO/k5U5C51ywwdb0fr4XO98yGW
         5uc81tDdS9fXwuidJrMgIsko2+aJeqV95om1can6tYig3EkDwlLEpHixEUhSBc1QVnT9
         tIvMggmkraWQNbF2b+aO7yFVgWaTBkhdTz6j3ZFgogRaA6KqFWEchZFoY2lJ99SxsfTT
         efOshjXFxHVX1uNnFu+B6nsN7MtXKpjN5iGuszIAziynL7BJCfIIuNaokJvCj0SJ2Uje
         u5Yg==
X-Gm-Message-State: APjAAAVRrZJ/+5TsGAuBvpmJ3oI/AMjLmcLnBgAg3LCUXbnJAp9eX7CB
        TIPp4cX0gw+m+R22lRu8amLrJmO6liurI9KMvydpyA==
X-Google-Smtp-Source: APXvYqwEzOWxmDU2hzC1zPRylpvjjoZt28pQ2PYdPEiCuZ7rfM0W+z1jPp1YoebhIrWOl9wxHRIIw7LZrVnkRnisqn8=
X-Received: by 2002:a17:902:9a95:: with SMTP id w21mr26531027plp.336.1569948065411;
 Tue, 01 Oct 2019 09:41:05 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000927a7b0586561537@google.com> <MN2PR18MB263783F52CAD4A335FD8BB34A01A0@MN2PR18MB2637.namprd18.prod.outlook.com>
 <CACT4Y+aQzBkAq86Hx4jNFnAUzjXnq8cS2NZKfeCaFrZa__g-cg@mail.gmail.com>
 <MN2PR18MB26372D98386D79736A7947EEA0140@MN2PR18MB2637.namprd18.prod.outlook.com>
 <MN2PR18MB263710E8F1F8FFA06B2EDB3CA0EC0@MN2PR18MB2637.namprd18.prod.outlook.com>
 <CAAeHK+z8MBNikw_x50Crf8ZhOhcF=uvPHakvBx44K77xHRUNfg@mail.gmail.com>
 <87k1bhb20j.fsf@kamboji.qca.qualcomm.com> <MN2PR18MB263724E4791927DF1AE009B1A0AD0@MN2PR18MB2637.namprd18.prod.outlook.com>
In-Reply-To: <MN2PR18MB263724E4791927DF1AE009B1A0AD0@MN2PR18MB2637.namprd18.prod.outlook.com>
From:   Andrey Konovalov <andreyknvl@google.com>
Date:   Tue, 1 Oct 2019 18:40:53 +0200
Message-ID: <CAAeHK+w6Po=8cYRDXZBHY6ZpFLc_ysmxsuGmxGzpvfdZw6ySrw@mail.gmail.com>
Subject: Re: [EXT] INFO: trying to register non-static key in del_timer_sync (2)
To:     Ganapathi Bhat <gbhat@marvell.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+dc4127f950da51639216@syzkaller.appspotmail.com>,
        "amitkarwar@gmail.com" <amitkarwar@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "huxinming820@gmail.com" <huxinming820@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nishants@marvell.com" <nishants@marvell.com>,
        "syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 14, 2019 at 4:08 PM Ganapathi Bhat <gbhat@marvell.com> wrote:
>
> Hi Dmitry/Kalle,
>
> > >>
> > >> Hi Dmitry,
> > >>
> > >> We have a patch to fix this:
> > >> https://patchwork.kernel.org/patch/10990275/
> > >
> > > Hi Ganapathi,
> > >
> > > Has this patch been accepted anywhere? This bug is still open on syzbot.
> >
> > The patch is in "Changes Requested" state which means that the author is
> > supposed to send a new version based on the review comments.
> We will address the review comments and try to push the updated version soon;

Hi Ganapathi,

I was wondering if you've posted the updated version of the fix?

Thanks!

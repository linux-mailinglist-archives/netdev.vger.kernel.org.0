Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D46D91690A
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 19:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727425AbfEGRXE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 13:23:04 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:36782 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726406AbfEGRXD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 May 2019 13:23:03 -0400
Received: by mail-qt1-f194.google.com with SMTP id a17so5824537qth.3
        for <netdev@vger.kernel.org>; Tue, 07 May 2019 10:23:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=NNP9eV+b9sJZJsQPk/KhvvBIeKZ5PvoMypZPDX1Y+RU=;
        b=YifbW5DWJf5KJ7Sax6ODXtyDIEkIvz9LklBW4NG029IewL+nvxOqLWI0fRs+uDGfHA
         SG1gVvdwDJtD4gTGC2YKwBoGZyiZsPmsZ0qzaViVXKyLxq0xTtYseFvdPi85wYsjDLmZ
         PaNDOy8Qq4oEPpPAUi3GzB5mR5Rl9dw9jtaLO6mCFTgB3dF+GM2fvlFF++mZDyMifeIp
         YfLEB4NJnqFGZ410oigvuZTWSZPVbzbpud2Wotb/1gE10IqDF0CKs8Tz8bGhN1L3rgM9
         z8grety2qWXGlcerdM0M1o7W19H3fttT+K3KgLUkgalFjputMVyH/ADfQVLoM+pFi3Ai
         ZWlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=NNP9eV+b9sJZJsQPk/KhvvBIeKZ5PvoMypZPDX1Y+RU=;
        b=qevR8eScvziHr5PFr67Y8fRMRyHMrVE+JrwUjR5pIZTm3eJSxvNZjb2T5q60yN5cJd
         3NNqume2Gp4FK4Q+gu2hODkYL7F9cktTAIP94RJ7T78Wy9K3y0RVCamS0Uh3fMvNhT3v
         Y2Li5OJggXkwPJJlubSCovhkh98KLzzW8jOqPpwm3VgyfIpcERssXwb4c6p6Iq5c+AUa
         XjB6wvUW8bRM2Nsh+JFtv52KiCVA/9781wrj/CGEthJ0c8kZvJbWlqsLqTrOpjzxPenz
         m2LLtlQY8DS8EPg7SZUHFw+YhpP1FDmRCRhA9yG2Y+Ue2qhTU6MTlJQKCDMxODz4cSFf
         Ta0w==
X-Gm-Message-State: APjAAAVSk9oYDT/+KbsaENfeVA57yhBcVeZvu1fvOyPSCoxNbEoydOGp
        bLXYkQGskm6kwW/UERCRSnAeKw==
X-Google-Smtp-Source: APXvYqzbEH1cb8ZhF66V6NtOY1C6FOTSqJuu9uHPCG/z6GyRjEXi9cKyxfIDOXQ2TIYrPKJbyzGclA==
X-Received: by 2002:a0c:ee29:: with SMTP id l9mr22915982qvs.151.1557249782811;
        Tue, 07 May 2019 10:23:02 -0700 (PDT)
Received: from cakuba.hsd1.ca.comcast.net ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id o37sm7629557qte.55.2019.05.07.10.23.01
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 07 May 2019 10:23:02 -0700 (PDT)
Date:   Tue, 7 May 2019 10:22:53 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Edward Cree <ecree@solarflare.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        "Cong Wang" <xiyou.wangcong@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Anjali Singhai Jain <anjali.singhai@intel.com>,
        Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [RFC PATCH net-next 2/3] flow_offload: restore ability to
 collect separate stats per action
Message-ID: <20190507102253.37b6681d@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <1b37d659-5a2b-6130-e8d6-c15d6f57b55e@solarflare.com>
References: <alpine.LFD.2.21.1905031603340.11823@ehc-opti7040.uk.solarflarecom.com>
        <20190504022759.64232fc0@cakuba.netronome.com>
        <db827a95-1042-cf74-1378-8e2eac356e6d@mojatatu.com>
        <1b37d659-5a2b-6130-e8d6-c15d6f57b55e@solarflare.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 7 May 2019 13:27:15 +0100, Edward Cree wrote:
> On 06/05/2019 13:41, Jamal Hadi Salim wrote:
> > On 2019-05-04 2:27 a.m., Jakub Kicinski wrote: =20
> >> On Fri, 3 May 2019 16:06:55 +0100, Edward Cree wrote: =20
> >>> Introduce a new offload command TC_CLSFLOWER_STATS_BYINDEX, similar to
> >>> =C2=A0 the existing TC_CLSFLOWER_STATS but specifying an action_index=
 (the
> >>> =C2=A0 tcfa_index of the action), which is called for each stats-havi=
ng action
> >>> =C2=A0 on the rule.=C2=A0 Drivers should implement either, but not bo=
th, of these
> >>> =C2=A0 commands. =20
> >>
> >> It feels a little strange to me to call the new stats updates from
> >> cls_flower, if we really want to support action sharing correctly.
> >>
> >> Can RTM_GETACTION not be used to dump actions without dumping the
> >> classifiers?=C2=A0 If we dump from the classifiers wouldn't that lead =
to
> >> stale stats being returned? =20
> >
> > Not sure about the staleness factor, but:
> > For efficiency reasons we certainly need the RTM_GETACTION approach
> > (as you stated above we dont need to dump all that classifier info if
> > all we want are stats). This becomes a big deal if you have a lot
> > of stats/rules. =20
>=20
> I don't know much of anything about RTM_GETACTION, but it doesn't appear
> =C2=A0to be part of the current "tc offload" world, which AIUI is very mu=
ch
> =C2=A0centred around cls_flower.=C2=A0 I'm just trying to make counters in
> =C2=A0cls_flower offload do 'the right thing' (whatever that may be), any=
thing
> =C2=A0else is out of scope.

I understand, and you are correct that the action sharing is not part
of the current "tc offload" world.  My point is that you are making it
part of the offload world, so it'd be best if it could be done well
from the start.

People trying to make the code do the right thing just in their narrow
use case brings us the periodic rewrites of the TC offload
infrastructure, and every time we do it some use cases get broken :/

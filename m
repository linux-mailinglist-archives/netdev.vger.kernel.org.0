Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2CED10942C
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 20:24:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbfKYTYQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 14:24:16 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:35278 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725818AbfKYTYP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 14:24:15 -0500
Received: by mail-lf1-f68.google.com with SMTP id r15so9023104lff.2
        for <netdev@vger.kernel.org>; Mon, 25 Nov 2019 11:24:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=MNmBp2YVpYlWXvbacbjEHT2PxlEuwzZsgfcr1Jyh5MQ=;
        b=eIN3TKVzfVXmHSqgu0DV/O2P/bb7TjjbBOKaHEdwvW+LlpInyodLFScR6csGgRKFJ7
         Zn7PMsaBZhfYR76SXYO1+twoZAAwJLRKunpHUYE8GLPE4T3dmLzAlZENTnn5oUKer3bV
         J2uA/J3fYk9aTPzxP83AG5deXYfPEzLfKbNlvA1dlhndFWRmnl0bzHNrnAhEFVno2VuP
         e65ckUVEPwino7VLf0/UyhC0cw+5gEthDWGBd148eWmjyXK/Kz/kz1pbHFEfSYtHoUNN
         6yDnzEXT20hjF+qaaJJtTE1HgW6npaMYIi00/qQQZVJa+b8Gfj7aQaeM9wmzGrqiuYoc
         yQ/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=MNmBp2YVpYlWXvbacbjEHT2PxlEuwzZsgfcr1Jyh5MQ=;
        b=HIHbymHPKS/b9f+2iBmZ83t5Ejhxzbv7zFzQSCUE8BxmXfSF8MrYmJ/5OGPYUylTPT
         44TkSfUGHwP8vZex6CPPNc8r+MjfqVewI4+DdCDX3PS2fUVsfxxwbMY1+9QQH3RnylrE
         XArProqdsJ5aaXLCJv3fV8FgpWR0OKjpHCrycN4xhnYrfHodE0efkRxs7ERmbp4Jo+N/
         i4dRR297Wj3G3LnRsCZi5zkMympUHxpLCslt5wTEWB8eopizT0kLwELdHAbfZ8lT+xkn
         KZd1XuAFalcVKtiNri5wgNMMo30OMlOrLONXQqTSGrDlH9++zyXToIF4+5BhCF37pSMU
         4L/Q==
X-Gm-Message-State: APjAAAUH/nkTY0F8np37xWRiSvjbxYb9CtN1KgZRXPWEnBh61tSS9ViB
        Y9bCTEjiR4RQymMygwuQbG3xog==
X-Google-Smtp-Source: APXvYqxawKHUwhQwSOqnPHBN9XPt90LccuiVciZwSc5vsO49ng90SQEzd1PccYx5xM0JEO2kUM39Xg==
X-Received: by 2002:a19:8104:: with SMTP id c4mr16214376lfd.191.1574709853677;
        Mon, 25 Nov 2019 11:24:13 -0800 (PST)
Received: from cakuba.hsd1.ca.comcast.net ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id 13sm4049915lfr.78.2019.11.25.11.24.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2019 11:24:13 -0800 (PST)
Date:   Mon, 25 Nov 2019 11:23:59 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Thomas Falcon <tlfalcon@linux.ibm.com>
Cc:     netdev@vger.kernel.org, linuxppc-dev@ozlabs.org,
        dnbanerg@us.ibm.com, brking@linux.vnet.ibm.com,
        julietk@linux.vnet.ibm.com
Subject: Re: [PATCH net 0/4] ibmvnic: Harden device commands and queries
Message-ID: <20191125112359.7a468352@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <52660c98-efd6-16e7-e66d-3528e5b32d3d@linux.ibm.com>
References: <1574451706-19058-1-git-send-email-tlfalcon@linux.ibm.com>
        <20191123174925.30b73917@cakuba.netronome.com>
        <52660c98-efd6-16e7-e66d-3528e5b32d3d@linux.ibm.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Nov 2019 12:40:42 -0600, Thomas Falcon wrote:
> On 11/23/19 7:49 PM, Jakub Kicinski wrote:
> > On Fri, 22 Nov 2019 13:41:42 -0600, Thomas Falcon wrote: =20
> >> This patch series fixes some shortcomings with the current
> >> VNIC device command implementation. The first patch fixes
> >> the initialization of driver completion structures used
> >> for device commands. Additionally, all waits for device
> >> commands are bounded with a timeout in the event that the
> >> device does not respond or becomes inoperable. Finally,
> >> serialize queries to retain the integrity of device return
> >> codes. =20
> > I have minor comments on two patches, but also I think it's
> > a little late in the release cycle for putting this in net.
> >
> > Could you target net-next and repost ASAP so it still makes
> > it into 5.5?
>=20
> Thank you, sorry for the late response.=C2=A0 I will make the requested=20
> changes ASAP, but I've missed the net-next window.=C2=A0 What should I ta=
rget=20
> for v2?

You're right, sticking to "net" makes sense at this point.

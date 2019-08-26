Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 845909D8F4
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 00:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbfHZWQQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 18:16:16 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:44884 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726278AbfHZWQQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 18:16:16 -0400
Received: by mail-ed1-f65.google.com with SMTP id a21so28535362edt.11
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 15:16:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=scqZ67HEn+EHMEKWjK7++vsr41mrloeIEGiZ+3NAJJ4=;
        b=XTTrNl+8WEDkme/nn0dCQXOhthFT0wru9XgC5VTgeJLobZmLiLP+7WSXs7KCsGBhEz
         vFwB9tIGSqP4ci2LbAgPN5sX/P933Y5m1BpKpkiYG+Jr3Xoe8Xjq0JOp3DaX6LMZZDbF
         t+H1nmHznRAE3hbdjjvh3b4+mowE/8WLBHRS43uCqE9laCUkOrprLG/WsGUOCvDkgNVo
         eYJr39oU+e5Cj4TPZcs37RslOMeLkabqZGHTpAOevopR+ox3Srpsc9cR/fl1wqgZK17W
         th7mM/py/o9j/o3nmQh950FR8pff3TDcIGgX0L74f68KBPVsgP5pm9h198frsjJyxBUm
         F7Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=scqZ67HEn+EHMEKWjK7++vsr41mrloeIEGiZ+3NAJJ4=;
        b=fNT3CRSdtdSNVOmriC22AVRITUf33AYdBDfz0ho6WidlyeqeniF2nsue2mWGsz8Kfd
         YIDDNHmX8Waq2jdiLyEBGDJCrA2uiD/bRBNS2+I008ab867oyEqaTU2UPhAIDRzd4C+E
         bV8H0GmnAcQ0NJRfOVD0d4Id+Gry+EUH7uW1/U1YN1UTaZvRp6iNBVp8a/3O8jQHbNTA
         nc9Nrx0nba05sY8OyufieFbtLCkkP5P8Y9f3J50JKRJGzXy75raUi3UEd2ei1eCWM3ia
         9Y6HcRlf1iFy0zlDCKkNq/wzEsFOwsurbsfJd/4IkR6ImUrbzCwVYELGnvZauXIX0wC7
         Md6Q==
X-Gm-Message-State: APjAAAU3OsW472q1YdP8sSbcAsNvPHZ92LyIaDxs6yHKtHgODUrpBj1W
        R2dzqZmagfnlEmAOydLVrBPFAHpxXB4=
X-Google-Smtp-Source: APXvYqz8xfbJ+hl6MpdDGAmrPTzVb2NXHuP1Pp+IIP/tm6GFAlm2Mq7k/iPMBQC+TkQBrDQYQKFzhw==
X-Received: by 2002:a17:906:6c90:: with SMTP id s16mr18967242ejr.62.1566857773896;
        Mon, 26 Aug 2019 15:16:13 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id t24sm1530512eds.45.2019.08.26.15.16.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2019 15:16:13 -0700 (PDT)
Date:   Mon, 26 Aug 2019 15:15:52 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Stephen Hemminger <sthemmin@microsoft.com>, dcbw@redhat.com,
        Michal Kubecek <mkubecek@suse.cz>,
        Andrew Lunn <andrew@lunn.ch>, parav@mellanox.com,
        Saeed Mahameed <saeedm@mellanox.com>,
        mlxsw <mlxsw@mellanox.com>
Subject: Re: [patch net-next rfc 3/7] net: rtnetlink: add commands to add
 and delete alternative ifnames
Message-ID: <20190826151552.4f1a2ad9@cakuba.netronome.com>
In-Reply-To: <5d79fba4-f82e-97a7-7846-fd1de089a95b@gmail.com>
References: <CAJieiUi+gKKc94bKfC-N5LBc=FdzGGo_8+x2oTstihFaUpkKSA@mail.gmail.com>
        <20190809062558.GA2344@nanopsycho.orion>
        <CAJieiUj7nzHdRUjBpnfL5bKPszJL0b_hKjxpjM0RGd9ocF3EoA@mail.gmail.com>
        <5e7270a1-8de6-1563-4e42-df37da161b98@gmail.com>
        <20190810063047.GC2344@nanopsycho.orion>
        <b0a9ec0d-c00b-7aaf-46d4-c74d18498698@gmail.com>
        <3b1e8952-e4c2-9be5-0b5c-d3ce4127cbe2@gmail.com>
        <20190812083139.GA2428@nanopsycho>
        <b43ad33c-ea0c-f441-a550-be0b1d8ca4ef@gmail.com>
        <20190813065617.GK2428@nanopsycho>
        <20190826160916.GE2309@nanopsycho.orion>
        <20190826095548.4d4843fe@cakuba.netronome.com>
        <5d79fba4-f82e-97a7-7846-fd1de089a95b@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Aug 2019 15:46:43 -0600, David Ahern wrote:
> On 8/26/19 10:55 AM, Jakub Kicinski wrote:
> > On Mon, 26 Aug 2019 18:09:16 +0200, Jiri Pirko wrote:  
> >> DaveA, Roopa. Do you insist on doing add/remove of altnames in the
> >> existing setlist command using embedded message op attrs? I'm asking
> >> because after some time thinking about it, it still feels wrong to me :/
> >>
> >> If this would be a generic netlink api, we would just add another couple
> >> of commands. What is so different we can't add commands here?
> >> It is also much simpler code. Easy error handling, no need for
> >> rollback, no possibly inconsistent state, etc.  
> > 
> > +1 the separate op feels like a better uapi to me as well.
> > 
> > Perhaps we could redo the iproute2 command line interface to make the
> > name the primary object? Would that address your concern Dave and Roopa?
> 
> No, my point is exactly that a name is not a primary object. A name is
> an attribute of a link - something that exists for the convenience of
> userspace only. (Like the 'protocol' for routes, rules and neighbors.)
> 
> Currently, names are changed by RTM_NEWLINK/RTM_SETLINK. Aliases are
> added and deleted by RTM_NEWLINK/RTM_SETLINK. Why is an alternative name
> so special that it should have its own API?

My feeling is that it's better to introduce operations for this
sub-object than mux everything via setlink :( The use of netlink 
in more recent APIs like devlink is much more liberal when it comes 
to ops and the result is much more convenient and clean IMHO.

Weren't there multiple problems with the size of the RTM_NEWLINK
notification already? Adding multiple sizeable strings to it won't
help there either :S

Do you foresee a need for the alias to be updated atomically with other
RTM_SETLINK changes?

> If only 1 alt name was allowed, then RTM_NEWLINK/RTM_SETLINK would
> suffice. Management of it would have the same semantics as an alias -
> empty string means delete, non-empty string sets the value.
> 
> So really the push for new RTM commands is to handle an unlimited number
> of alt names with the ability to change / delete any one of them. Has
> the need for multiple alternate ifnames been fully established? (I don't
> recall other than a discussion about parallels to block devices.)

I feel like I already posted this link, but here it is again:

https://www.freedesktop.org/wiki/Software/systemd/PredictableNetworkInterfaceNames/

IMHO the fact that there are multiple naming schemes in systemd today
is proof enough.


To be clear my (probably over-engineered) position is that "user-
-understandable" interface names had became a dead end already long
time ago. We should move away from strings and try to build APIs or at
least user space where device can be selected based on attributes
directly. The names are nothing else than a random grab bag of
attributes sprintf()-ed together, anyway. 

The naming done by udev is inherently racy and over and over again we
run into races and issues because OvS or some other piece of userspace
gets confused and e.g. enslaves ports to wrong bridges.

Longer names I just a band aid. But I'm under no illusion I can convince
people to spend time working on an attribute-based scheme.. ;)

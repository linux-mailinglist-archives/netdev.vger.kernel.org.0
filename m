Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6665962A88
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 22:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405172AbfGHUnb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 16:43:31 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42057 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732097AbfGHUn3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 16:43:29 -0400
Received: by mail-wr1-f66.google.com with SMTP id a10so17484102wrp.9
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 13:43:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:date:message-id:in-reply-to:references:user-agent
         :subject:mime-version:content-transfer-encoding;
        bh=R0n8Z37vuiuzeaTBasaidvJ2vtLHJp1fKzn9/xOAFFs=;
        b=qEe8JyevDvWoiXnfHt851w8szzgIcwnnHRmpgqbeaAhl2GWMtBhVG8q4RWkAhQw/P2
         A1eFQlsVU8dKrcpXLuGhb5UWn/t3Ip8YoWt/CApR21GPzHcuu0ac3l5D7y4Nc0/n84Ba
         1OSZwvA4gECQryu4Y76iWMjvGKUrI/5Zp3dzMqNJqxXeKBC4BDi/0F4TIw0+MN+7Irtr
         ad3VGJDCtsnt9ESmUIXSqUY565I//px3FGiJQMEonbSXgIzUi1rxcIQlMDAe9Jw2KnXr
         CFOSAjDm7IHvK4yUwHB/NlotTcYkYKYATSGRDUMvYxDL/CO5hexUmi6pvRkY9W5tNVO2
         asgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:subject:mime-version
         :content-transfer-encoding;
        bh=R0n8Z37vuiuzeaTBasaidvJ2vtLHJp1fKzn9/xOAFFs=;
        b=VLFtWJ1DJuyaAlZTAccWubwFid1QT4WQHQnPNEmRxnEh+Cpamyq76qlV4sRXk2hErh
         b+q4mEWffPe91ZnCgzRiTRLBbhZfI7quD/tKdmt8RfUovQ5rKS6JSRtREBZxVhqtnGw5
         Rrv4VMkbR6rLz2+lwbl+Vnv3UbGw70GFDDv38ZIjcaotAt0rgcMJukE/b53JuC4jYGvc
         5cL/KDr8uR3GMxmY+ivJQBfbR7zXLBKymKAzuA9ZK23yXpTknJmFKMPNZZQ7J+VTgMNg
         qtO8MtBsbWPq1i8tas92Kq3tCxwtd5o4lJ4iElQxdDEg4rBbxuxLqbA6WmZvWi7DBC8l
         tYMA==
X-Gm-Message-State: APjAAAUVbZX5NraIyIP7d6vDOPdYejS2yN84683CFt+bJoXrQVlH/mjq
        Pw1m81nZstCb5Q5Qu3LIbI4K
X-Google-Smtp-Source: APXvYqwBcNCqy91bApdr+fF8sBg0c2jOBD02VfVxlPkgirUQznuNw302/Bj1HSjN1wTHDZ2B4vbj0Q==
X-Received: by 2002:adf:ce82:: with SMTP id r2mr19648257wrn.223.1562618607220;
        Mon, 08 Jul 2019 13:43:27 -0700 (PDT)
Received: from [10.149.209.138] ([46.189.67.107])
        by smtp.gmail.com with ESMTPSA id y7sm536362wmm.19.2019.07.08.13.43.25
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 08 Jul 2019 13:43:26 -0700 (PDT)
From:   Paul Moore <paul@paul-moore.com>
To:     Richard Guy Briggs <rgb@redhat.com>
CC:     Tycho Andersen <tycho@tycho.ws>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        <containers@lists.linux-foundation.org>,
        <linux-api@vger.kernel.org>,
        "Linux-Audit Mailing List" <linux-audit@redhat.com>,
        <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <sgrubb@redhat.com>,
        <omosnace@redhat.com>, <dhowells@redhat.com>, <simo@redhat.com>,
        Eric Paris <eparis@parisplace.org>, <ebiederm@xmission.com>,
        <nhorman@tuxdriver.com>
Date:   Mon, 08 Jul 2019 22:43:23 +0200
Message-ID: <16bd353a5f8.280e.85c95baa4474aabc7814e68940a78392@paul-moore.com>
In-Reply-To: <20190708181237.5poheliito7zpvmc@madcap2.tricolour.ca>
References: <20190529145742.GA8959@cisco>
 <CAHC9VhR4fudQanvZGYWMvCf7k2CU3q7e7n1Pi7hzC3v_zpVEdw@mail.gmail.com>
 <20190529153427.GB8959@cisco>
 <CAHC9VhSF3AjErX37+eeusJ7+XRw8yuPsmqBTRwc9EVoRBh_3Tw@mail.gmail.com>
 <20190529222835.GD8959@cisco>
 <CAHC9VhRS66VGtug3fq3RTGHDvfGmBJG6yRJ+iMxm3cxnNF-zJw@mail.gmail.com>
 <20190530170913.GA16722@mail.hallyn.com>
 <CAHC9VhThLiQzGYRUWmSuVfOC6QCDmA75BDB7Eg7V8HX4x7ymQg@mail.gmail.com>
 <20190530212900.GC5739@cisco>
 <CAHC9VhT5HPt9rCJoDutdvA3r1Y1GOHfpXe2eJ54atNC1=Vd8LA@mail.gmail.com>
 <20190708181237.5poheliito7zpvmc@madcap2.tricolour.ca>
User-Agent: AquaMail/1.20.0-1462 (build: 102100002)
Subject: Re: [PATCH ghak90 V6 02/10] audit: add container id
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On July 8, 2019 8:12:56 PM Richard Guy Briggs <rgb@redhat.com> wrote:

> On 2019-05-30 19:26, Paul Moore wrote:
>> On Thu, May 30, 2019 at 5:29 PM Tycho Andersen <tycho@tycho.ws> wrote:
>>> On Thu, May 30, 2019 at 03:29:32PM -0400, Paul Moore wrote:
>>>>
>>>>
>>>> [REMINDER: It is an "*audit* container ID" and not a general
>>>> "container ID" ;)  Smiley aside, I'm not kidding about that part.]
>>>
>>> This sort of seems like a distinction without a difference; presumably
>>> audit is going to want to differentiate between everything that people
>>> in userspace call a container. So you'll have to support all this
>>> insanity anyway, even if it's "not a container ID".
>>
>> That's not quite right.  Audit doesn't care about what a container is,
>> or is not, it also doesn't care if the "audit container ID" actually
>> matches the ID used by the container engine in userspace and I think
>> that is a very important line to draw.  Audit is simply given a value
>> which it calls the "audit container ID", it ensures that the value is
>> inherited appropriately (e.g. children inherit their parent's audit
>> container ID), and it uses the value in audit records to provide some
>> additional context for log analysis.  The distinction isn't limited to
>> the value itself, but also to how it is used; it is an "audit
>> container ID" and not a "container ID" because this value is
>> exclusively for use by the audit subsystem.  We are very intentionally
>> not adding a generic container ID to the kernel.  If the kernel does
>> ever grow a general purpose container ID we will be one of the first
>> ones in line to make use of it, but we are not going to be the ones to
>> generically add containers to the kernel.  Enough people already hate
>> audit ;)
>>
>>>> I'm not interested in supporting/merging something that isn't useful;
>>>> if this doesn't work for your use case then we need to figure out what
>>>> would work.  It sounds like nested containers are much more common in
>>>> the lxc world, can you elaborate a bit more on this?
>>>>
>>>>
>>>> As far as the possible solutions you mention above, I'm not sure I
>>>> like the per-userns audit container IDs, I'd much rather just emit the
>>>> necessary tracking information via the audit record stream and let the
>>>> log analysis tools figure it out.  However, the bigger question is how
>>>> to limit (re)setting the audit container ID when you are in a non-init
>>>> userns.  For reasons already mentioned, using capable() is a non
>>>> starter for everything but the initial userns, and using ns_capable()
>>>> is equally poor as it essentially allows any userns the ability to
>>>> munge it's audit container ID (obviously not good).  It appears we
>>>> need a different method for controlling access to the audit container
>>>> ID.
>>>
>>> One option would be to make it a string, and have it be append only.
>>> That should be safe with no checks.
>>>
>>> I know there was a long thread about what type to make this thing. I
>>> think you could accomplish the append-only-ness with a u64 if you had
>>> some rule about only allowing setting lower order bits than those that
>>> are already set. With 4 bits for simplicity:
>>>
>>> 1100         # initial container id
>>> 1100 -> 1011 # not allowed
>>> 1100 -> 1101 # allowed, but now 1101 is set in stone since there are
>>>       # no lower order bits left
>>>
>>> There are probably fancier ways to do it if you actually understand
>>> math :)
>>
>> ;)
>>
>>> Since userns nesting is limited to 32 levels (right now, IIRC), and
>>> you have 64 bits, this might be reasonable. You could just teach
>>> container engines to use the first say N bits for themselves, with a 1
>>> bit for the barrier at the end.
>>
>> I like the creativity, but I worry that at some point these
>> limitations are going to be raised (limits have a funny way of doing
>> that over time) and we will be in trouble.  I say "trouble" because I
>> want to be able to quickly do an audit container ID comparison and
>> we're going to pay a penalty for these larger values (we'll need this
>> when we add multiple auditd support and the requisite record routing).
>>
>> Thinking about this makes me also realize we probably need to think a
>> bit longer about audit container ID conflicts between orchestrators.
>> Right now we just take the value that is given to us by the
>> orchestrator, but if we want to allow multiple container orchestrators
>> to work without some form of cooperation in userspace (I think we have
>> to assume the orchestrators will not talk to each other) we likely
>> need to have some way to block reuse of an audit container ID.  We
>> would either need to prevent the orchestrator from explicitly setting
>> an audit container ID to a currently in use value, or instead generate
>> the audit container ID in the kernel upon an event triggered by the
>> orchestrator (e.g. a write to a /proc file).  I suspect we should
>> start looking at the idr code, I think we will need to make use of it.
>
> To address this, I'd suggest that it is enforced to only allow the
> setting of descendants and to maintain a master list of audit container
> identifiers (with a hash table if necessary later) that includes the
> container owner.
>
> This also allows the orchestrator/engine to inject processes into
> existing containers by checking that the audit container identifier is
> only used again by the same owner.
>
> I have working code for both.

Just a quick note that due to some holiday travel I'm not going to be able =
to adequately respond to your latest messages on this thread for at least a=
nother week, likely a bit more.  I'm only checking mail to put out fires, a=
nd the audit container ID work tends to be something that starts them ;)

--
paul moore
www.paul-moore.com





Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8490D3A374E
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 00:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230469AbhFJWpH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 18:45:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24279 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230451AbhFJWpG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 18:45:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623364989;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=V5yzb21nbg0WXga74jQ6xsvVDaavF5Xwuj6ArQYTfOY=;
        b=M1YK6yb9pe86NT7q23TTdZXC8HIbtgqxKNSyyqoazVmHG5Mu/Lr8N+givFtOfgxrhiFqHQ
        6SzzFq5UnvMGyX1e+TRf8vYJAkoyFeX+PmUjoZEUn7pKbEJVz4nr+cWH4PJ5XI2FCaIQzi
        kHxksnZewNzAcbwUOMCbV47xU7MYCXk=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-376-BeH2F4T_PuyjjSRyyJbC1g-1; Thu, 10 Jun 2021 18:43:08 -0400
X-MC-Unique: BeH2F4T_PuyjjSRyyJbC1g-1
Received: by mail-ed1-f72.google.com with SMTP id h23-20020aa7c5d70000b029038fed7b27d5so14895612eds.21
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 15:43:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=V5yzb21nbg0WXga74jQ6xsvVDaavF5Xwuj6ArQYTfOY=;
        b=ZU8qTyf29JxeqQwgtmrqrVGXeL6UJ+eelf0aCclW7sPDUkPt3l5RcCmti/VrX/G8Vk
         sBckDKuQbQRikOKWTlhQf3f0IGE0/NY1PqUWU22Do0dMzZqcrrkyJKz0by7gAMbahOlH
         6uZIL82MIgKplr0JjOyj3qd0rv8hgBZI+ugcSyq2sue7IvxIeJUIg8ZBnQV++fdz7V9H
         itZjW8Vus9xRRWCaemHIo6LetLJWl7gqTjlYo6JC5nO7LlK6kQoR/ymMgvNaOHFFawhh
         0qtQ2hxxoRXXM5JN70LzjryJBaFlLG67aWJadIKAzfXZU8MMDQ24QKXxf5zItjI2nen4
         fXWw==
X-Gm-Message-State: AOAM531OTRZJhxHnQhNfJDzMVYhd6cg25bbvNelU2xhGRZBQtqZDiqlI
        9ZYJzZuXsVSTteI6CSgXMc6qjXN0kUD9TxkN24nhsX2Vn7xkCJ3P1Cy+t4xQLYhE9dDStaftia+
        SA+WEuvU/d1IjBKur
X-Received: by 2002:a17:906:e44:: with SMTP id q4mr686718eji.120.1623364987091;
        Thu, 10 Jun 2021 15:43:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx3Of813xtsFNMUywKOhdyaCRUGvejxpofMzlcEGjq5vOPDHQSpbSONXjsKSs4Nlp7UDRGRdQ==
X-Received: by 2002:a17:906:e44:: with SMTP id q4mr686706eji.120.1623364986880;
        Thu, 10 Jun 2021 15:43:06 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id ci12sm1489704ejc.17.2021.06.10.15.43.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 15:43:06 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 627F718071E; Fri, 11 Jun 2021 00:43:05 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Shuah Khan <skhan@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        David Hildenbrand <david@redhat.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Greg KH <greg@kroah.com>, Christoph Lameter <cl@gentwo.de>,
        Theodore Ts'o <tytso@mit.edu>, Jiri Kosina <jikos@kernel.org>,
        ksummit@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-api@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: Maintainers / Kernel Summit 2021 planning kick-off
In-Reply-To: <37e8d1a5-7c32-8e77-bb05-f851c87a1004@linuxfoundation.org>
References: <YH2hs6EsPTpDAqXc@mit.edu>
 <nycvar.YFH.7.76.2104281228350.18270@cbobk.fhfr.pm>
 <YIx7R6tmcRRCl/az@mit.edu>
 <alpine.DEB.2.22.394.2105271522320.172088@gentwo.de>
 <YK+esqGjKaPb+b/Q@kroah.com>
 <c46dbda64558ab884af060f405e3f067112b9c8a.camel@HansenPartnership.com>
 <b32c8672-06ee-bf68-7963-10aeabc0596c@redhat.com>
 <5038827c-463f-232d-4dec-da56c71089bd@metux.net>
 <20210610182318.jrxe3avfhkqq7xqn@nitro.local>
 <YMJcdbRaQYAgI9ER@pendragon.ideasonboard.com>
 <20210610152633.7e4a7304@oasis.local.home>
 <37e8d1a5-7c32-8e77-bb05-f851c87a1004@linuxfoundation.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 11 Jun 2021 00:43:05 +0200
Message-ID: <87tum5uyrq.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Shuah Khan <skhan@linuxfoundation.org> writes:

> On 6/10/21 1:26 PM, Steven Rostedt wrote:
>> On Thu, 10 Jun 2021 21:39:49 +0300
>> Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:
>> 
>>> There will always be more informal discussions between on-site
>>> participants. After all, this is one of the benefits of conferences, by
>>> being all together we can easily organize ad-hoc discussions. This is
>>> traditionally done by finding a not too noisy corner in the conference
>>> center, would it be useful to have more break-out rooms with A/V
>>> equipment than usual ?
>> 
>> I've been giving this quite some thought too, and I've come to the
>> understanding (and sure I can be wrong, but I don't think that I am),
>> is that when doing a hybrid event, the remote people will always be
>> "second class citizens" with respect to the communication that is going
>> on. Saying that we can make it the same is not going to happen unless
>> you start restricting what people can do that are present, and that
>> will just destroy the conference IMO.
>> 
>> That said, I think we should add more to make the communication better
>> for those that are not present. Maybe an idea is to have break outs
>> followed by the presentation and evening events that include remote
>> attendees to discuss with those that are there about what they might
>> have missed. Have incentives at these break outs (free stacks and
>> beer?) to encourage the live attendees to attend and have a discussion
>> with the remote attendees.
>> 
>> The presentations would have remote access, where remote attendees can
>> at the very least write in some chat their questions or comments. If
>> video and connectivity is good enough, perhaps have a screen where they
>> can show up and talk, but that may have logistical limitations.
>> 
>
> You are absolutely right that the remote people will have a hard time
> participating and keeping up with in-person participants. I have a
> couple of ideas on how we might be able to improve remote experience
> without restricting in-person experience.
>
> - Have one or two moderators per session to watch chat and Q&A to enable
>    remote participants to chime in and participate.
> - Moderators can make sure remote participation doesn't go unnoticed and
>    enable taking turns for remote vs. people participating in person.
>
> It will be change in the way we interact in all in-person sessions for
> sure, however it might enhance the experience for remote attendees.

This is basically how IETF meetings function: At the beginning of every
session, a volunteer "jabber scribe" is selected to watch the chat and
relay any questions to a microphone in the room. And the video streaming
platform has a "virtual queue" that remove participants can enter and
the session chairs are then responsible for giving people a chance to
speak. Works reasonably well, I'd say :)

-Toke


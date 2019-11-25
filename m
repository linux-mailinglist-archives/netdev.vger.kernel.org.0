Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88FA610911E
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 16:39:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728601AbfKYPjE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 10:39:04 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40698 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728539AbfKYPjE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 10:39:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574696343;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dneEZm6PaWRTyfChWz3XoPps5h37w7jv4igTylbUPX0=;
        b=eWGt2oNT4vGAOSIthrtnNifYzMnwNn6hTBCVWXLnyPNyNR9M07JAtmMqOJq4Z3kucXFFYT
        7rwecUoCZkRZbLA/RgTPykYhpg4p1kk445QdXyFjBjyFHJWUB42fKdY5Wem6ba2vPGOdnj
        V5MyGtIER8EN+tfbJyArQnOzgYC0giU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-377-820Ckze9PraQlY4AioAdBA-1; Mon, 25 Nov 2019 10:39:00 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BB1AC1010B29;
        Mon, 25 Nov 2019 15:38:58 +0000 (UTC)
Received: from dhcp-25.97.bos.redhat.com (unknown [10.18.25.127])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0D23F60C81;
        Mon, 25 Nov 2019 15:38:56 +0000 (UTC)
From:   Aaron Conole <aconole@redhat.com>
To:     Pravin Shelar <pshelar@ovn.org>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, ovs dev <dev@openvswitch.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 1/2] openvswitch: support asymmetric conntrack
References: <20191108210714.12426-1-aconole@redhat.com>
        <CAOrHB_B1ueESwUQSkb7BuFGCCyKKqognoWbukTHo2jTajNca6w@mail.gmail.com>
        <f7twobwyl53.fsf@dhcp-25.97.bos.redhat.com>
Date:   Mon, 25 Nov 2019 10:38:56 -0500
In-Reply-To: <f7twobwyl53.fsf@dhcp-25.97.bos.redhat.com> (Aaron Conole's
        message of "Mon, 18 Nov 2019 15:39:20 -0500")
Message-ID: <f7t7e3o9d9r.fsf@dhcp-25.97.bos.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.2 (gnu/linux)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: 820Ckze9PraQlY4AioAdBA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Aaron Conole <aconole@redhat.com> writes:

> Pravin Shelar <pshelar@ovn.org> writes:
>
>> On Fri, Nov 8, 2019 at 1:07 PM Aaron Conole <aconole@redhat.com> wrote:
>>>
>>> The openvswitch module shares a common conntrack and NAT infrastructure
>>> exposed via netfilter.  It's possible that a packet needs both SNAT and
>>> DNAT manipulation, due to e.g. tuple collision.  Netfilter can support
>>> this because it runs through the NAT table twice - once on ingress and
>>> again after egress.  The openvswitch module doesn't have such capabilit=
y.
>>>
>>> Like netfilter hook infrastructure, we should run through NAT twice to
>>> keep the symmetry.
>>>
>>> Fixes: 05752523e565 ("openvswitch: Interface with NAT.")
>>> Signed-off-by: Aaron Conole <aconole@redhat.com>
>>
>> The patch looks ok. But I am not able apply it. can you fix the encoding=
.
>
> Hrrm.  I didn't make any special changes (just used git send-email).  I
> will look at spinning a second patch.

Pravin,

I tried the following:

  10:36:59 aconole@dhcp-25 {(312434617cb1...)} ~/git/linux$ curl http://pat=
chwork.ozlabs.org/patch/1192219/mbox/ > test.patch
    % Total    % Received % Xferd  Average Speed   Time    Time     Time  C=
urrent
                                   Dload  Upload   Total   Spent    Left  S=
peed
  100  4827  100  4827    0     0   8824      0 --:--:-- --:--:-- --:--:-- =
 8808
  10:37:21 aconole@dhcp-25 {(312434617cb1...)} ~/git/linux$ git am test.pat=
ch
  Applying: openvswitch: support asymmetric conntrack
  10:37:24 aconole@dhcp-25 {(f759cc2b7323...)} ~/git/linux$=20


Can you check your mailer settings?  The patchwork mbox worked fine, and
I was able to apply from my own mbox as well.

-Aaron


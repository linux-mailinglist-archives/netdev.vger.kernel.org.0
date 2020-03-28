Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA6A61968FD
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 20:43:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726981AbgC1Tn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Mar 2020 15:43:57 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:41791 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725807AbgC1Tn4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Mar 2020 15:43:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585424634;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vpQwKWo/17n/h8b6dDma1QUlo5wTceRnvlY+HtgX2yk=;
        b=LKqWJnNZK04pRd++I7icFW+/vCGkubKmDBO7oXsH7+aEwsdIKbQqZ7UK9XIJU7YX4/UCEx
        N8UW8z6yNUq8+b0AIBFajUVyW3ItPV75+dOEKwhqp3Ki4Seem4gE6RrxHLMhMvSvr+V1NI
        9BTrdJtmhCQY8adudN5/4QpB0kWS1To=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-72-umb0lp4nOVCQCarWl1hzYg-1; Sat, 28 Mar 2020 15:43:52 -0400
X-MC-Unique: umb0lp4nOVCQCarWl1hzYg-1
Received: by mail-lj1-f200.google.com with SMTP id w6so1999244ljh.11
        for <netdev@vger.kernel.org>; Sat, 28 Mar 2020 12:43:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=vpQwKWo/17n/h8b6dDma1QUlo5wTceRnvlY+HtgX2yk=;
        b=lbLE1ih3ny8zay0lmpfbNuHSau4Pc2ZLzbXq41g7YdtX6+eWO1qFI0JgfYWp408jP3
         QFZu4JeySvkVbKLHQy6a+TK+QXAwbXRyeagYgksE7fJSi60yzf8u9IUKdQ7OHPZmohvG
         fuOMfmXRDFkZxGYq5y8UseDepI5+lpL6YzgwEW8u/oedv5hwEkSk1YwTbT9XFNA2gBRu
         zJzzJQ3gHxNpH0QgN596/xsmAfdfMckqcdKu9pV0nMkIHyNzFNMMmpxe6yM3c1xceEmE
         9Zv9zlji3E4G5RpW4jiK/pCMVgBpfxN+FNvPxb0ONKKzftUlaCOTKqgCpXQW9ED5gsdt
         EsxQ==
X-Gm-Message-State: AGi0PubqcduV+0w3qa1sg90tddNf88+prwzC6oznerCTGf5oSzyN1UH9
        JMu7n4Nx7RkmKejl4NnAD1SbW6Ho2bq8XgKPXRWKIL7yboCxvDKC4lV9Yq8yhcTRBaDqEdMFN4Y
        hVBB9jRtZwU+rVxyZ
X-Received: by 2002:a2e:9b55:: with SMTP id o21mr2817491ljj.74.1585424631095;
        Sat, 28 Mar 2020 12:43:51 -0700 (PDT)
X-Google-Smtp-Source: APiQypIlYLEYpodnKfESsuUVCWNnOXFm59Wq/ON0ymJXHaGk467Hzv1zJUjvA2uBt9EN0SyioadfSg==
X-Received: by 2002:a2e:9b55:: with SMTP id o21mr2817473ljj.74.1585424630782;
        Sat, 28 Mar 2020 12:43:50 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id c13sm4305925ljj.37.2020.03.28.12.43.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Mar 2020 12:43:49 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id C55A318158B; Sat, 28 Mar 2020 20:43:47 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Andrey Ignatov <rdna@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing program when attaching XDP
In-Reply-To: <CAEf4BzbK_pn6ox6JZLTjb7FYrpWGZrSqCApEY9xbWiFwwLKaGw@mail.gmail.com>
References: <158462359206.164779.15902346296781033076.stgit@toke.dk>
 <875zez76ph.fsf@toke.dk>
 <20200320103530.2853c573@kicinski-fedora-PC1C0HJN>
 <5e750bd4ebf8d_233f2ab4c81425c4ce@john-XPS-13-9370.notmuch>
 <CAEf4BzbWa8vdyLuzr_nxFM3BtT+hhzjCe9UQF8Y5cN+sVqa72g@mail.gmail.com>
 <87tv2f48lp.fsf@toke.dk>
 <CAEf4BzYutqP0yAy-KyToUNHM6Z-6C-XaEwK25pK123gejG0s9Q@mail.gmail.com>
 <87h7ye3mf3.fsf@toke.dk>
 <CAEf4BzY+JsmxCfjMVizLWYU05VS6DiwKE=e564Egu1jMba6fXQ@mail.gmail.com>
 <87tv2e10ly.fsf@toke.dk>
 <CAEf4BzY1bs5WRsvr5UbfqV9UKnwxmCUa9NQ6FWirT2uREaj7_g@mail.gmail.com>
 <87369wrcyv.fsf@toke.dk>
 <CAEf4BzZKvuPz8NZODYnn4DOcjPnj5caVeOHTP9_D3=wL0nVFfw@mail.gmail.com>
 <87pncznvjy.fsf@toke.dk>
 <CAEf4BzaPQ6=h8a6Ngz638AtL4LmBLLVMV+_-YLMR=Ls+drd5HQ@mail.gmail.com>
 <87lfnmm35r.fsf@toke.dk>
 <CAEf4Bza7zQ+ii4SH=4gJqQdyCp9pm6qGAsBOwa0MG5AEofC2HQ@mail.gmail.com>
 <87wo75l9yj.fsf@toke.dk>
 <CAEf4Bza8P3yT08NAaqN2EKaaBFumzydbtYQmSvLxZ99=B6_iHw@mail.gmail.com>
 <87o8shl1y4.fsf@toke.dk>
 <CAEf4BzbK_pn6ox6JZLTjb7FYrpWGZrSqCApEY9xbWiFwwLKaGw@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sat, 28 Mar 2020 20:43:47 +0100
Message-ID: <87blogl0y4.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Fri, Mar 27, 2020 at 6:10 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>>
>> > On Fri, Mar 27, 2020 at 3:17 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke=
@redhat.com> wrote:
>> >>
>> >> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>> >>
>> >> > Please stop dodging. Just like with "rest of the kernel", but really
>> >> > "just networking" from before.
>> >>
>> >> Look, if we can't have this conversation without throwing around
>> >> accusations of bad faith, I think it is best we just take Ed's advice
>> >> and leave it until after the merge window.
>> >>
>> >
>> > Toke, if me pointing out that you are dodging original discussion and
>> > pivoting offends you,
>>
>> It does, because I'm not. See below.
>>
>> > But if you are still with me, let's look at this particular part of
>> > discussion:
>> >
>> >>> >> For XDP there is already a unique handle, it's just implicit: Each
>> >>> >> netdev can have exactly one XDP program loaded. So I don't really=
 see
>> >>> >> how bpf_link adds anything, other than another API for the same t=
hing?
>> >>> >
>> >>> > I certainly failed to explain things clearly if you are still aski=
ng
>> >>> > this. See point #2, once you attach bpf_link you can't just replace
>> >>> > it. This is what XDP doesn't have right now.
>> >>>
>> >>> Those are two different things, though. I get that #2 is a new
>> >>> capability provided by bpf_link, I was just saying #1 isn't (for XDP=
).
>> >>
>> >> bpf_link is combination of those different things... Independently
>> >> they are either impossible or insufficient. I'm not sure how that
>> >> doesn't answer your question:
>> >>
>> >>> So I don't really see
>> >>> how bpf_link adds anything, other than another API for the same thin=
g?
>> >>
>> >> Please stop dodging. Just like with "rest of the kernel", but really
>> >> "just networking" from before.
>> >
>> > You said "So I don't really see how bpf_link adds anything, other than
>> > another API for the same thing?". I explained that bpf_link is not the
>> > same thing that exists already, thus it's not another API for the same
>> > thing. You picked one property of bpf_link and claimed it's the same
>> > as what XDP has right now. "I get that #2 is a new capability provided
>> > by bpf_link, I was just saying #1 isn't (for XDP)". So should I read
>> > that as if you are agreeing and your original objection is rescinded?
>> > If yes, then good, this part is concluded and I'm sorry if I
>> > misinterpreted your answer.
>>
>> Yes, I do believe that was a misinterpretation. Basically, by my
>> paraphrasing, our argument goes something like this:
>>
>> What you said was: "bpf_link adds three things: 1. unique attachment
>> identifier, 2. auto-detach and 3. preventing others from overriding it".
>>
>> And I replied: "1. already exists for XDP, 2. I don't think is the right
>> behaviour for XDP, and 3. I don't see the point of - hence I don't
>> believe bpf_link adds anything useful for my use case"
>>
>> I was not trying to cherry-pick any of the properties, and I do
>> understand that 2. and 3. are new properties; I just disagree about how
>> useful they are (and thus whether they are worth introducing another API
>> for).
>>
>
> I appreciate you summarizing. It makes everything clearer. I also
> don't have much to add after so many rounds.

Right, great, let's leave this here, then :)

>> > But if not, then you again are picking one properly and just saying
>> > "but XDP has it" without considering all of bpf_link properties as a
>> > whole. In that case I do think you are arguing not in good faith.
>>
>> I really don't see how you could read my emails and come to that
>> conclusion. But obviously you did, so I'll take that into consideration
>> and see if I can express myself clearer in the future. But know this: I
>> never deliberately argue in bad faith; so even if it seems like I am,
>> please extend me the courtesy of assuming that this is due to either a
>> misunderstanding or an honest difference in opinion. I will try to do
>> the same for you.
>
> I guess me citing your previous replies and pointing out to
> inconsistencies (at least from my interpretation of them) should have
> been a signal ;)

Well, it was my impression that we were making progress on this; which
is why I got so offended when I suddenly felt myself being accused :/

> But I do assume good faith to the extent possible, which is why we are
> still here at almost 80 emails in.

Great, thank you! And yeah, those emails did stack up, didn't they? I do
think we've made some progress, though, miscommunication and all :)

>> > Simple as that. I also hope I don't have to go all the way back to
>> > "rest of the kernel", pivoted to "just networking" w.r.t.
>> > subsystem-specific configuration/attachment APIs to explain another
>> > reference.
>>
>> Again, I was not trying to "pivot", or attempting to use rhetorical
>> tricks to "win" or anything like that. I was making an observation about
>> how it's natural that when two subsystems interact, it's quite natural
>> that there will be clashes between their different "traditions". And
>> that how you view the subsystems' relationship with each other obviously
>> affects your opinion of what the right thing to do is in such a
>> situation. I never meant to imply anything concrete about BPF in
>> anything other than a networking context. And again, I don't understand
>> how you could read that out of what I wrote, but I'll take the fact that
>> you did into consideration in the future.
>
> Because "rest of the kernel" meant "cgroup subsystem" as well, which
> was clearly not true case w.r.t. BPF. But alright, water under the
> bridge, let's just not use generalizations too much going forward.

Sure, sounds good.

-Toke


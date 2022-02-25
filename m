Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00A314C49F2
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 17:01:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237269AbiBYQBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 11:01:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242532AbiBYQBm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 11:01:42 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C97071F1257
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 08:01:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645804868;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=w9dhf5wwXThEWj3cf5cdg0iQ4nnKBS281ReX6j2zl94=;
        b=LQoGrd5ow00atqzmxBRrvkHkrDUWjecKJLLFHYqdK6yWxRh7A5GDadpK1murPE+x1izfSt
        RMM+jkk4TzuxLUdzvHGnsjQh/FtSvBOH74cGHbsCyAKRur9WHgzu7D6vMZRhLloOj/579m
        smyxCO2eapWGnpYsDMo+RRyPnVJTrPg=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-1-7xvO1GCjOF-jcuJcQiwfdQ-1; Fri, 25 Feb 2022 11:01:07 -0500
X-MC-Unique: 7xvO1GCjOF-jcuJcQiwfdQ-1
Received: by mail-pl1-f199.google.com with SMTP id q14-20020a17090311ce00b001501afc15e2so2641408plh.2
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 08:01:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w9dhf5wwXThEWj3cf5cdg0iQ4nnKBS281ReX6j2zl94=;
        b=thRJCg642bgsa/yWJYUfqj4xktJapbE1UqrDwYA5TuJw3oJVXyQWxEaDKJHD2/C6zJ
         Ds17PM35oAqwU9lhpYNMbSy3TnKGaCOK9l+1NVNqtxr90pggkuGKq6UTHZMhJeKfEV5r
         o7DOD8CK8sVSIQMrPnLkVf1XjmTY+PpCxhWaS3i9FWElxiAWcI4puXNIkJKW7rBKwzeb
         xg/ccFByfGekzywWqyE1CiQm8SkdC6hoRGdnBEtbuuqFdHxeXQ3SnJEEVC04bkwJESbN
         b7jh3b4Sqf4sw5K1r5NUWQlYIFAqCG4snqITWMk//FTuzajrgC17QU4g+Jb/u0py4dgI
         NhTg==
X-Gm-Message-State: AOAM533oyHOYI+g7m1rtPI1f9cEPNs2CUgv+fo95Wg/Iwzk9RxZwpef1
        D/uDvB4HVZuNRamie2OQPWurHB+qGR5+soRA6qtKAUKC6DUwuFiN2955E8NBEJs4JNo1tn1s7Jp
        kFfJQxzhozELsCWjvCk8ovxkqHbGWHPZg
X-Received: by 2002:a17:90a:560a:b0:1bc:72e7:3c13 with SMTP id r10-20020a17090a560a00b001bc72e73c13mr3732905pjf.246.1645804865664;
        Fri, 25 Feb 2022 08:01:05 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwnDxShEdRtw82Y2ve6Ld5WQ6/BwpdkROL6sfF8knWeb+GpiwWno7qGoJpgjLzdJaMj+agHtqJVEo21uvWjJLE=
X-Received: by 2002:a17:90a:560a:b0:1bc:72e7:3c13 with SMTP id
 r10-20020a17090a560a00b001bc72e73c13mr3732820pjf.246.1645804864803; Fri, 25
 Feb 2022 08:01:04 -0800 (PST)
MIME-Version: 1.0
References: <20220224110828.2168231-1-benjamin.tissoires@redhat.com>
 <YhdsgokMMSEQ0Yc8@kroah.com> <CAO-hwJJcepWJaU9Ytuwe_TiuZUGTq_ivKknX8x8Ws=zBFUp0SQ@mail.gmail.com>
 <YhjbzxxgxtSxFLe/@kroah.com>
In-Reply-To: <YhjbzxxgxtSxFLe/@kroah.com>
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
Date:   Fri, 25 Feb 2022 17:00:53 +0100
Message-ID: <CAO-hwJJpJf-GHzU7-9bhMz7OydNPCucTtrm=-GeOf-Ee5-aKrw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 0/6] Introduce eBPF support for HID devices
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>,
        Tero Kristo <tero.kristo@linux.intel.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Peter Hutterer <peter.hutterer@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 25, 2022 at 2:38 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Thu, Feb 24, 2022 at 02:49:21PM +0100, Benjamin Tissoires wrote:
> > Hi Greg,
> >
> > Thanks for the quick answer :)
> >
> > On Thu, Feb 24, 2022 at 12:31 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Thu, Feb 24, 2022 at 12:08:22PM +0100, Benjamin Tissoires wrote:
> > > > Hi there,
> > > >
> > > > This series introduces support of eBPF for HID devices.
> > > >
> > > > I have several use cases where eBPF could be interesting for those
> > > > input devices:
> > > >
> > > > - simple fixup of report descriptor:
> > > >
> > > > In the HID tree, we have half of the drivers that are "simple" and
> > > > that just fix one key or one byte in the report descriptor.
> > > > Currently, for users of such devices, the process of fixing them
> > > > is long and painful.
> > > > With eBPF, we could externalize those fixups in one external repo,
> > > > ship various CoRe bpf programs and have those programs loaded at boot
> > > > time without having to install a new kernel (and wait 6 months for the
> > > > fix to land in the distro kernel)
> > >
> > > Why would a distro update such an external repo faster than they update
> > > the kernel?  Many sane distros update their kernel faster than other
> > > packages already, how about fixing your distro?  :)
> >
> > Heh, I'm going to try to dodge the incoming rhel bullet :)
> >
> > It's true that thanks to the work of the stable folks we don't have to
> > wait 6 months for a fix to come in. However, I think having a single
> > file to drop in a directory would be easier for development/testing
> > (and distribution of that file between developers/testers) than
> > requiring people to recompile their kernel.
> >
> > Brain fart: is there any chance we could keep the validated bpf
> > programs in the kernel tree?
>
> That would make the most sense to me.  And allow "slow" distros to
> override the HID bpf quirks easily if they need to.  If you do that,
> then most of my objections of the "now the code is in two places that
> you have to track" goes away :)

Unfortunately, I don't think we will be able to have all the bpf
programs in the kernel.

I would say programs that "enable" a device (report descriptor fixup,
events override, single key remapping) which are there to make the
device fully functional could likely be stored and loaded by the
kernel. I have yet to figure out if the suggestion from Yonghong Song
allows me to also load the bpf program or if it's just a repo in the
tree for the sources.

However, for USI pens (or any other functionality that needs a new
high level kernel interface) I don't think we will have them here.
Unless we want to also bind the public API to dbus (or graybus maybe),
the bpf program should live in the userspace program so it can update
it and not be tied to the decisions in the kernel (I'll go more into
detail later in this reply).

So that's going to be a half and half solution :/

>
> > > I'm all for the idea of using ebpf for HID devices, but now we have to
> > > keep track of multiple packages to be in sync here.  Is this making
> > > things harder overall?
> >
> > Probably, and this is also maybe opening a can of worms. Vendors will
> > be able to say "use that bpf program for my HID device because the
> > firmware is bogus".
> >
> > OTOH, as far as I understand, you can not load a BPF program in the
> > kernel that uses GPL-declared functions if your BPF program is not
> > GPL. Which means that if firmware vendors want to distribute blobs
> > through BPF, either it's GPL and they have to provide the sources, or
> > it's not happening.
>
> You can make the new HID bpf api only availble to GPL programs, and if I
> were you, that's what I would do just to keep any legal issues from
> coming up.  Also bundling it with the kernel makes it easier.

Looking at kernel/bpf/bpf_lsm.c I can confirm that it should be easy
to prevent a program from binding to HID if it's not GPL :)

>
> > I am not entirely clear on which plan I want to have for userspace.
> > I'd like to have libinput on board, but right now, Peter's stance is
> > "not in my garden" (and he has good reasons for it).
> > So my initial plan is to cook and hold the bpf programs in hid-tools,
> > which is the repo I am using for the regression tests on HID.
>
> Why isn't the hid regression tests in the kernel tree also?  That would
> allow all of the testers out there to test things much easier than
> having to suck down another test repo (like Linaro and 0-day and
> kernelci would be forced to do).

2 years ago I would have argued that the ease of development of
gitlab.fd.o was more suited to a fast moving project.

Now... The changes in the core part of the code don't change much so
yes, merging it in the kernel might have a lot of benefits outside of
what you said. The most immediate one is that I could require fixes to
be provided with a test, and merge them together, without having to
hold them until Linus releases a new version.

If nobody complains of having the regression tests in python with
pytest and some Python 3.6+ features, that is definitely something I
should look for.

>
> > I plan on building a systemd intrinsic that would detect the HID
> > VID/PID and then load the various BPF programs associated with the
> > small fixes.
> > Note that everything can not be fixed through eBPF, simply because at
> > boot we don't always have the root partition mounted.
>
> Root partitions are now on HID devices?  :)

Sorry for not being clear :)

I mean that if you need a bpf program to be loaded from userspace at
boot to make your keyboard functional, then you need to have the root
partition mounted (or put the program in the initrd) so udev can load
it. Now if your keyboard is supposed to give the password used to
decrypt your root partition but you need a bpf program on that said
partition to make it functional, you are screwed :)

>
> > > > - Universal Stylus Interface (or any other new fancy feature that
> > > >   requires a new kernel API)
> > > >
> > > > See [0].
> > > > Basically, USI pens are requiring a new kernel API because there are
> > > > some channels of communication our HID and input stack are not capable
> > > > of. Instead of using hidraw or creating new sysfs or ioctls, we can rely
> > > > on eBPF to have the kernel API controlled by the consumer and to not
> > > > impact the performances by waking up userspace every time there is an
> > > > event.
> > >
> > > How is userspace supposed to interact with these devices in a unified
> > > way then?  This would allow random new interfaces to be created, one
> > > each for each device, and again, be a pain to track for a distro to keep
> > > in sync.  And how are you going to keep the ebpf interface these
> > > provides in sync with the userspace program?
> >
> > Right now, the idea we have is to export the USI specifics through
> > dbus. This has a couple of advantages: we are not tied to USI and can
> > "emulate" those parameters by storing them on disk instead of in the
> > pen, and this is easily accessible from all applications directly.
> >
> > I am trying to push to have one implementation of that dbus service
> > with the Intel and ChromeOS folks so general linux doesn't have to
> > recreate it. But if you look at it, with hidraw nothing prevents
> > someone from writing such a library/daemon in its own world without
> > sharing it with anybody.
> >
> > The main advantage of eBPF compared to hidraw is that you can analyse
> > the incoming event without waking userspace and only wake it up when
> > there is something noticeable.
>
> That is a very good benefit, and one that many battery-powered devices
> would like.
>
> > In terms of random interfaces, yes, this is a good point. But the way
> > I see it is that we can provide one kernel API (eBPF for HID) which we
> > will maintain and not have to maintain forever a badly designed kernel
> > API for a specific device. Though also note that USI is a HID standard
> > (I think there is a second one), so AFAICT, the same bpf program
> > should be able to be generic enough to be cross vendor. So there will
> > be one provider only for USI.
>
> Ok, that's good to know.
>
> <good stuff snipped>
>
> > Yeah, I completely understand the view. However, please keep in mind
> > that most of it (though not firewall and some corner cases of tracing)
> > is already possible to do through hidraw.
> > One other example of that is SDL. We got Sony involved to create a
> > nice driver for the DualSense controller (the PS5 one), but they
> > simply ignore it and use plain HID (through hidraw). They have the
> > advantage of this being cross-platform and can provide a consistent
> > experience across platforms. And as a result, in the kernel, we have
> > to hands up the handling of the device whenever somebody opens a
> > hidraw node for those devices (Steam is also doing the same FWIW).
> >
> > Which reminds me that I also have another use-case: joystick
> > dead-zone. You can have a small filter that configures the dead zone
> > and doesn't even wake up userspace for those hardware glitches...
>
> hidraw is a big issue, and I understand why vendors use that and prefer
> it over writing a kernel driver.  They can control it and ship it to
> users and it makes life easier for them.  It's also what Windows has
> been doing for decades now, so it's a comfortable interface for them to
> write their code in userspace.
>
> But, now you are going to ask them to use bpf instead?  Why would they
> switch off of hidraw to use this api?  What benefit are you going to
> provide them here for that?

Again, there are 2 big classes of users of hid-bpf ("you" here is a
developer in general):
1. you need to fix your device
2. you need to add a new kernel API

2. can be entirely done with hidraw:
- you open the hidraw node
- you parse every incoming event
- out of that you build up your high level API

This is what we are doing in libratbag for instance to support gaming
mice that need extra features. We try to not read every single event,
but some mice are done in a way we don't have a choice.

With bpf, you could:
- load the bpf program
- have the kernel (bpf program) parse the incoming report without
waking up user space
- when something changes (a given button is pressed) the bpf program
notifies userspace with an event
- then userspace builds its own API on top of it (forward that change
through dbus for example)

As far as 1., the aim is not to replace hidraw but the kernel drivers
themselves:
instead of having a formal driver loaded in the kernel, you can rely
on a bpf program to do whatever needs to be done to make the device
working.

If the FW is wrong and the report descriptor messes up a button
mapping, you can change that with bpf instead of having a specific
driver for it.
And of course, using hidraw for that just doesn't work because the
event stream you get from hidraw is for the process only. In BPF, we
can change the event flow for anybody, which allows much more power
(but this is scarier too).

This class of bpf program should actually reside in the kernel tree so
everybody can benefit from it (circling back to your first point).

So I am not deprecating hidraw nor I am not asking them to use bpf instead.
But when you are interested in just one byte in the report, bpf allows
you to speed up your program and save battery.

>
> This is why I've delayed doing bpf for USB.  Right now we have a nice
> cross-platform way to write userspace USB drivers using usbfs/libusb.
> All a bpf api to USB would be doing is much the same thing that libusb
> does, for almost no real added benefit that I can tell.
>
> USB, is a really "simple" networking like protocol (send/recieve
> packets).  So it ties into the bpf model well.  But the need to use bpf
> for USB so far I don't have a real justification.
>
> And the same thing here.  Yes it is cool, and personally I love it, but
> what is going to get people off of hidraw to use this instead?  You
> can'd drop hidraw now (just like I can't drop usbfs), so all this means
> is we have yet-another-way to do something on the system.  Is that a
> good idea?  I don't know.
>
> Also you mention dbus as the carrier for the HID information to
> userspace programs.  Is dbus really the right thing for sending streams
> of input data around?  Yes it will probably work, but I don't think it
> was designed for that at all, so the overhead involved might just
> overshadow any of the improvements you made using bpf.  And also, you
> could do this today with hidraw, right?

Let me go into more details regarding USI.
Peter drafted a WIP for the dbus API at
https://gitlab.freedesktop.org/whot/usid. Unfortunately that's the
only tangent thing I can share right now for it, and it doesn't even
have the bpf part ;).

Basically the dbus API will export just the USI bits we care about:
- Preferred Color: the 8-bit Web color or 24 bit RGB color assigned to
the device
- Preferred Line Width: the physical width (e.g. 2mm)
- Preferred Line Style: One of Ink, Pencil, Highlighter, Chisel
Marker, Brush, No Preference.

The rest of the event stream will still continue to go through evdev,
and not dbus.

The bpf program we should have here parses the incoming report and
whenever there is a change in those 3 properties above, it raises an
event to the dbus daemon which will in turn forward that to its
clients.
On the other side, when a client needs to have a color change for
instance, it sets the dbus property and then the dbus daemon might
either store the data on disk or on the pen through bpf and HID.

So yes, you can do that with hidraw but that means you need to parse
all incoming reports in userspace for events that will likely occur
every once in a while.

In my mind, the dbus operations here are to replace the kernel API you
might want to create instead. In that case, Tero started with 2
in-kernel possibilities: a sysfs entry we could read/write, or a new
ioctl attached to the evdev node (it was actually a separate char
device).

>
> > Anyway, IOW, I think the bpf approach will allow kernel-like
> > performances of hidraw applications, and I would be more inclined to
> > ask people to move their weird issue in userspace thanks to that.
>
> I like this from a "everyone should use bpf" point of view, but how are
> you going to tell people "use bpf over hidraw" in a way that gets them
> to do so?  If you have a good answer for that, I might just steal it for
> the bpf-USB interface as well :)
>

I don't think we can have a generic answer here unfortunately. It will
depend on the use case:
- SDL/Steam -> they are interested in the entire stream of events, so
we can't really tell them to use bpf, unless if they want to fix a
deadzone of a joystick
- if the idea is to fix the device (spurious event, wrong key mapping,
drift of one coordinate), hidraw doesn't apply, and bpf is IMO better
than writing a kernel module as long as we can ship them with the
kernel (because of the cost of compiling a driver/kernel and testing
is much higher than just inserting a BPF program in the running
kernel)
- if the idea is to add a new kernel API or functionality to a device
(a new haptic FF implementation, some USI properties, something unique
enough to not be generic and have a properly defined API), then bpf is
a good choice because by tying the bpf program with the high level API
from userspace we can ensure we don't have to maintain this kernel API
with all its bugs forever. And here, you could use hidraw but if you
need to filter a small amount of information in the event stream
instead of just using Set/Get reports, then BPF is much more
efficient.

I don't know enough about the USB use case you have for libusb (I know
mostly the input ones ;-P) to be able to give you an answer there.

Cheers,
Benjamin


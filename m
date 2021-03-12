Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8E433941B
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 18:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232493AbhCLQ7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 11:59:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232398AbhCLQ7t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 11:59:49 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4C5AC061574;
        Fri, 12 Mar 2021 08:59:49 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id c10so3177269ilo.8;
        Fri, 12 Mar 2021 08:59:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8lyG9mI2+ZJ9STRsO49iQYUUEtp1pPpZxebMdUf5OrU=;
        b=lOa/pXAUadrrdSUfTfsnb3u9ozA2I3n4dpJYV1nAZQ3IftoPv6nv0MKopf8+HxrPsJ
         DLugt+E+IRC3GDqzvl6dAtuBVuzGeR2reElxkayv+VhzxT1Eya4mvuxiYjyg6XVbT6iQ
         1Wwh7YoXz8Rrj7S4jKcthXJ3/qBE+y3kZbccxBs9Ef4XMoILwwvfUSxHi4G+bBspAgXs
         KYSjQpgYS+l0aseN1WIMVYMChTtZu44Sj/v7IGNhJTtPzLMElIN4V1T9xnXOqr8oT2j4
         DDBK2GTkN9R4dd1TLAhuhSylTzjop8abB1LeIHc+C8EITCLC/A5hVraS02E4I9gDGb7g
         +hww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8lyG9mI2+ZJ9STRsO49iQYUUEtp1pPpZxebMdUf5OrU=;
        b=QSlgiCkBzddeOUH3dXbB8khWS9RNs2vQ9M3aW5L9/WYtNfrlLjFnE4nf1tUeM2Q28g
         kGCLTc0V0+gegsiid/Hmid5y96zywyO0VGLy8rmGBq5XlBTY5emMDqw9tvWWCgceFhx8
         WYYSjZG/8bJeE3N+9aWBJOOZiNDWQyBdcq/LRtF+eeWVnRwf4hsDiA3m87FD5l9IsA7h
         jSytbKHFpp1KrCwM7zzvRw5x8I4HkN23NO9jEEsgUxriz+0CWJgN1MaPwfwDau7XQouo
         5Y9Ek++N8FpRe1wRNm3Dt70KXaT9TKj8uPqklG21J8gLQ5VX4IF4LRfzEin/6KpG+JVb
         BwhQ==
X-Gm-Message-State: AOAM5321/bfXJmqj1NWmMzj+fWFu6szHRNBshBckk69ojsC5l53bI6Bd
        e3gutdqvGjl2LZERO0/MTuobN+ZtQIwP8kJFfCA=
X-Google-Smtp-Source: ABdhPJyxhAZqqHgpN7WIcSRLeNGYeqqplMBUXvARRawTxYw/AyadyFWdybe5WkPRPdMigwFmCN6SbgSFFU26kRoUOeI=
X-Received: by 2002:a92:d18c:: with SMTP id z12mr3132686ilz.95.1615568389141;
 Fri, 12 Mar 2021 08:59:49 -0800 (PST)
MIME-Version: 1.0
References: <CAKgT0UevrCLSQp=dNiHXWFu=10OiPb5PPgP1ZkPN1uKHfD=zBQ@mail.gmail.com>
 <20210311181729.GA2148230@bjorn-Precision-5520> <CAKgT0UeprjR8QCQMCV8Le+Br=bQ7j2tCE6k6gxK4zCZML5woAA@mail.gmail.com>
 <20210311201929.GN2356281@nvidia.com> <CAKgT0Ud1tzpAWO4+5GxiUiHT2wEaLacjC0NEifZ2nfOPPLW0cg@mail.gmail.com>
 <20210311232059.GR2356281@nvidia.com> <CAKgT0Ud+gnw=W-2U22_iQ671himz8uWkr-DaBnVT9xfAsx6pUg@mail.gmail.com>
 <YEsK6zoNY+BXfbQ7@unreal>
In-Reply-To: <YEsK6zoNY+BXfbQ7@unreal>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 12 Mar 2021 08:59:38 -0800
Message-ID: <CAKgT0UfsoXayB72KD+H_h14eN7wiYtWCUjxKJxwiNKr44XUPfA@mail.gmail.com>
Subject: Re: [PATCH mlx5-next v7 0/4] Dynamically assign MSI-X vectors count
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        linux-rdma@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 11, 2021 at 10:32 PM Leon Romanovsky <leon@kernel.org> wrote:
>
> On Thu, Mar 11, 2021 at 06:53:16PM -0800, Alexander Duyck wrote:
> > On Thu, Mar 11, 2021 at 3:21 PM Jason Gunthorpe <jgg@nvidia.com> wrote:
> > >
> > > On Thu, Mar 11, 2021 at 01:49:24PM -0800, Alexander Duyck wrote:
> > > > > We don't need to invent new locks and new complexity for something
> > > > > that is trivially solved already.
> > > >
> > > > I am not wanting a new lock. What I am wanting is a way to mark the VF
> > > > as being stale/offline while we are performing the update. With that
> > > > we would be able to apply similar logic to any changes in the future.
> > >
> > > I think we should hold off doing this until someone comes up with HW
> > > that needs it. The response time here is microseconds, it is not worth
> > > any complexity
>
> <...>
>
> > Another way to think of this is that we are essentially pulling a
> > device back after we have already allocated the VFs and we are
> > reconfiguring it before pushing it back out for usage. Having a flag
> > that we could set on the VF device to say it is "under
> > construction"/modification/"not ready for use" would be quite useful I
> > would think.
>
> It is not simple flag change, but change of PCI state machine, which is
> far more complex than holding two locks or call to sysfs_create_file in
> the loop that made Bjorn nervous.
>
> I want to remind again that the suggestion here has nothing to do with
> the real use case of SR-IOV capable devices in the Linux.
>
> The flow is:
> 1. Disable SR-IOV driver autoprobe
> 2. Create as much as possible VFs
> 3. Wait for request from the user to get VM
> 4. Change MSI-X table according to requested in item #3
> 5. Bind ready to go VF to VM
> 6. Inform user about VM readiness
>
> The destroy flow includes VM destroy and unbind.
>
> Let's focus on solutions for real problems instead of trying to solve theoretical
> cases that are not going to be tested and deployed.
>
> Thanks

So part of the problem with this all along has been that you are only
focused on how you are going to use this and don't think about how
somebody else might need to use or implement it. In addition there are
a number of half measures even within your own flow. In reality if we
are thinking we are going to have to reconfigure every device it might
make sense to simply block the driver from being able to load until
you have configured it. Then the SR-IOV autoprobe would be redundant
since you could use something like the "offline" flag to avoid that.

If you are okay with step 1 where you are setting a flag to prevent
driver auto probing why is it so much more overhead to set a bit
blocking drivers from loading entirely while you are changing the
config space? Sitting on two locks and assuming a synchronous
operation is assuming a lot about the hardware and how this is going
to be used.

In addition it seems like the logic is that step 4 will always
succeed. What happens if for example you send the message to the
firmware and you don't get a response? Do you just say the request
failed let the VF be used anyway? This is another reason why I would
be much more comfortable with the option to offline the device and
then tinker with it rather than hope that your operation can somehow
do everything in one shot.

In my mind step 4 really should be 4 steps.

1. Offline VF to reserve it for modification
2. Submit request for modification
3. Verify modification has occurred, reset if needed.
4. Online VF

Doing it in that order allows for handling many more scenarios
including those where perhaps step 2 actually consists of several
changes to support any future extensions that are needed. Splitting
step 2 and 3 allows for an asynchronous event where you can wait if
firmware takes an excessively long time, or if step 2 somehow fails
you can then repeat or revert it to get back to a consistent state.
Lastly by splitting out the onlining step you can avoid potentially
releasing a broken VF to be reserved if there is some sort of
unrecoverable error between steps 2 and 3.

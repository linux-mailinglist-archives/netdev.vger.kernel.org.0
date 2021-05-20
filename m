Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6297C38AA3B
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 13:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234537AbhETLLS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 07:11:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38503 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240172AbhETLJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 07:09:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621508882;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=G2kGV7JGcXDvwAuWoTpd9Sm9lcKAHUa0j2YIDM1nVOw=;
        b=IiyeNSI43ukX3Jhd9GoGyI9r5ZQ0AJtScSPd11s78wBqmSJgv5Shn5BuJqFcwRCwLGjsM1
        RTTHqyJa7HrpCj/BBHeRZzcg4YT91Tjzxr+OBs26rRTivYWauHe1+MKwL86GmNr2ZrKSNT
        ORaLYKus3tmyzIAN1kseQADAWhgAo3Y=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-447-uplioC0zMtal55_zYoDklQ-1; Thu, 20 May 2021 07:07:58 -0400
X-MC-Unique: uplioC0zMtal55_zYoDklQ-1
Received: by mail-wm1-f69.google.com with SMTP id v2-20020a7bcb420000b0290146b609814dso1315457wmj.0
        for <netdev@vger.kernel.org>; Thu, 20 May 2021 04:07:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G2kGV7JGcXDvwAuWoTpd9Sm9lcKAHUa0j2YIDM1nVOw=;
        b=WIXm66COaz69WhSeMBvLUk73i3jiOFXhqVYGnkkJ447dnN+EMflFEdHFpt5wwr3Tqf
         iccsaApoxD3y3MfVADcRJYaYtqQReb2H90ffkbvdz1ANcqz0K3XEkgtqXFk5ZyPPl9LC
         +Rxtpcqmhq7a1U35wpAZp2let/T3WjPVtrtF1R2p8GrGnX9nMCM1/cnoHa6nY4q8e6Da
         yo48pLTcziqSmZHbVZyOCYCf6CY+j+qT3B+EFb7GIjnGjaVlEmbtzneOvHqI+YkN81Tn
         sGmHCPaV0LHR3pT8UIJ+V5mKuXkJfcVL+6n/tgE6ejtz/n9hgbZXBm6JCqYDFJRg3M+z
         YuPA==
X-Gm-Message-State: AOAM533cV6o0KwQL2WN0D/cUuCOKugbWBVutOATQnb+RXt0UEzSkOG1l
        Cm3i8iJPUaqwm+ZVL1PKtdsUF/nR6PhsUOBVu1ujCMT5mjObDUK8tVz4iep9vTDslJQ47HNVw8T
        p9N2wBD6pXlPaV1pk1DidxeSRJ8VWW5T8
X-Received: by 2002:a1c:50:: with SMTP id 77mr2950771wma.111.1621508877703;
        Thu, 20 May 2021 04:07:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxoPACfDoYEWebQzMsBrci68cud/CakLDkmpV0mwFhlv910nX0n+RSsSh+NkB+KFsjXPXXjJqQCVasrbLxTJvQ=
X-Received: by 2002:a1c:50:: with SMTP id 77mr2950750wma.111.1621508877523;
 Thu, 20 May 2021 04:07:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210518155231.38359-1-lariel@nvidia.com> <CALnP8ZYUsuBRpMZzU=F0711RVZmwGRvLBEk09aM6MKDhAGrMFQ@mail.gmail.com>
 <32e2a0ac-1102-3fd1-6094-052bd58415fe@nvidia.com>
In-Reply-To: <32e2a0ac-1102-3fd1-6094-052bd58415fe@nvidia.com>
From:   Andrea Claudi <aclaudi@redhat.com>
Date:   Thu, 20 May 2021 13:07:46 +0200
Message-ID: <CAPpH65zVzJpie9CmwJ6F5uyUq4C7dRfYV-yngwAFm+ARHdRd3g@mail.gmail.com>
Subject: Re: [PATCH iproute2-next 0/2] ] tc: Add missing ct_state flags
To:     Ariel Levkovich <lariel@nvidia.com>
Cc:     Marcelo Ricardo Leitner <mleitner@redhat.com>,
        linux-netdev <netdev@vger.kernel.org>, jiri@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 20, 2021 at 1:00 PM Ariel Levkovich <lariel@nvidia.com> wrote:
>
> On 5/20/21 4:15 AM, Marcelo Ricardo Leitner wrote:
> > On Tue, May 18, 2021 at 06:52:29PM +0300, Ariel Levkovich wrote:
> >> This short series is:
> >>
> > Is it me or this series didn't get to netdev@?
> > I can't find it in patchwork nor lore archives.
> >
> Neither do I. Not sure what happened.
>
> Should I just send it again?
>

Now that I look at it better, there is a double closed square bracket
on the subject. Not sure if this is related to the issue.
Ariel, I think you should submit this again to netdev.

Cheers,
Andrea


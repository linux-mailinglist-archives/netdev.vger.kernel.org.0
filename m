Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4FA14FA6D
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 20:52:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbgBATwE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Feb 2020 14:52:04 -0500
Received: from mail-oi1-f174.google.com ([209.85.167.174]:37038 "EHLO
        mail-oi1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbgBATwE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Feb 2020 14:52:04 -0500
Received: by mail-oi1-f174.google.com with SMTP id q84so10871334oic.4
        for <netdev@vger.kernel.org>; Sat, 01 Feb 2020 11:52:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aQ3uib3iLy6dkxb/g7vtRsyZF7HYX33b9z4ml49/vN0=;
        b=RlUjE8nbG9BUEpXYH9bERpKh+CUKsAsr47djFnQY1v2+9vo2KMzG0YFQhI9WadfcT8
         TUc6fV//RrU7p8dSRblgKLqQud5ufIqbfYnJ1Jy8Q9X4fQpDWlkPD/y1mVCYK6fIJEi7
         uW2cXO9SwN/CPmlJ57tKWZOJJp+ultUNAPKP2TJ4UwTkL+tLa7kOlvDjE/4ua3Auy5iZ
         qqjwGM2MsItb2Sj8wLxwcWB/YT2iH3HEVqcsywKirJWOPC+xZPqYqwP117bZbBxgW2bq
         +vwi5H2FzuhUicj9BQALTVP434OX9PxeeZsS23YFHyBrKAq2pkyDn4naSP82fQcpbh6H
         TpUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aQ3uib3iLy6dkxb/g7vtRsyZF7HYX33b9z4ml49/vN0=;
        b=uGIWbfAAo3IxgQ12gC0vSJ1WEgVRcWIbYaIuTO0k21ZHKENbLzzdvxoYRVFocpvSyR
         CKtUN/TkLSCqr9zFjeFcdKUPjoFeWOSN63vPxKw5J1J/d0isHRCUrGu8T2MQnK7q/3j3
         6+RoYJsCDQQaP3vmGQT+C61N8Br5F0im7DW+475mf8hHos9lOngHiXWgFpX/RHQ6FdlD
         gmPUjOFrPTYXbkgoe0jy78hcDw0RpRsA3jEN9/1y2GfmJqvzuH84sLyANX9sbPXt0yZZ
         dMRbdDmS3vG5JPC1xNIGjaAWOrWiG5alBacuwPqW07bPlRGe0fM/Ew3RKcm/esNOaQls
         loTA==
X-Gm-Message-State: APjAAAVB3Kiw9f84yOET33K8KBd2Mx4/ge9eW3lvIkF5MCD2+yOq8AZR
        ETCfM3C7lSV04q8onVk8FjEWq4WxSInabtOpYow=
X-Google-Smtp-Source: APXvYqzHKQ+qlOe6z+KE/BBv1rNnCyGJwxUVPsbFnIYPxaWuzshQ61E3o6L8h96/hstwWoJJs0EGjeyjU4+FrJInAH4=
X-Received: by 2002:aca:cf07:: with SMTP id f7mr836683oig.5.1580586723853;
 Sat, 01 Feb 2020 11:52:03 -0800 (PST)
MIME-Version: 1.0
References: <CAJx5YvHH9CoC8ZDz+MwG8RFr3eg2OtDvmU-EaqG76CiAz+W+5Q@mail.gmail.com>
 <CAM_iQpUcGr-MHhWBxhL01O-nxWg1NPM8siEPkYgckyDT+Ku3gA@mail.gmail.com> <20200201191441.GC23638@unicorn.suse.cz>
In-Reply-To: <20200201191441.GC23638@unicorn.suse.cz>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sat, 1 Feb 2020 11:51:52 -0800
Message-ID: <CAM_iQpXovVXKZDRJubATG1L8fLM-NQn-fDVWO2YiD8CJ7eoXtg@mail.gmail.com>
Subject: Re: Why is NIC driver queue depth driver dependent when it allocates
 system memory?
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Martin T <m4rtntns@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 1, 2020 at 11:14 AM Michal Kubecek <mkubecek@suse.cz> wrote:
>
> On Sat, Feb 01, 2020 at 11:08:37AM -0800, Cong Wang wrote:
> > On Thu, Jan 30, 2020 at 5:03 AM Martin T <m4rtntns@gmail.com> wrote:
> > >
> > > Hi,
> > >
> > > when I read the source code of for example tg3 driver or e1000e
> > > driver, then looks like the driver queue is allocated from system
> > > memory. For example, in e1000_ethtool.c kcalloc() is called to
> > > allocate GFP_KERNEL memory.
> > >
> > > If system memory is allocated, then why are there driver-dependent
> > > limits? For example, in my workstation the maximum RX/TX queue for the
> > > NIC using tg3 driver is 511 while maximum RX/TX queue for the NIC
> > > using e1000e driver is 4096:
> >
> > I doubt memory is a consideration for driver to decide the number
> > of queues. How many CPU's do you have? At least mellanox driver
> > uses the number of CPU's to determine the default value. Anyway,
> > you can change it to whatever you prefer.
>
> Martin was asking about ring sizes, not about number of queues.

Ah, sorry for reading it too quickly.

Thanks.

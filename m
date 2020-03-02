Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4CE1176856
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 00:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbgCBXkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 18:40:12 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:43251 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726728AbgCBXkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 18:40:12 -0500
Received: by mail-il1-f195.google.com with SMTP id o18so1079794ilg.10;
        Mon, 02 Mar 2020 15:40:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=cyfoOa/TKoH02XU+kxLNRHsFUzko3EuCG7r/YxSGrHI=;
        b=TobbcplPck1BbN5F+NI8A/Ddb003WmYS/FNcNXoeb4Ny2imgynmY277FG5l4iCYwdI
         4S0+BZLk2TP4lEKC3y87L0725US4HmjZtkRe+wZXvbiFmHp0/4uxAj7TD3Bi8jOCVNp4
         doVyXytubBHMzYgJ2feIEdWKn9aMDonnLMcjDf9bNlkmqD0K8UMvw21VVAWSx6fRt79/
         GA+kBG56y9JIQNvW52JP4ERQ4eu4/aNVVcZ42do/C3vfsMsVWw3wcYENTbykvXUe16v2
         5EwIy08+nGp/zZ+wo7+dqURBaj4KUA6jUgQFVfeB5JNb0Heo6/qjTn5ZdJfKsvsuo645
         +vlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=cyfoOa/TKoH02XU+kxLNRHsFUzko3EuCG7r/YxSGrHI=;
        b=sMAxzpWDF3dpRheLBAIWnQs5xfgYGxn+kiOy537nYQ75bQaKsiJyPbxJ9cEFPBQIL1
         p47kpO7rhBGVDPesU/8NBuHvvWAtap46OgEWXAghAMSLSA6Vlo7BYDB78fg0V021I1tn
         CHtCJ9V3iFPS0MNLAXSVAvouvxXUpX8lQtXht93xC9Iy0b57yE1KdVukrVGJlB7sz8h/
         Ix8lMStGh+2C64T0TnGLj8mDvgXWM09aqJiwK4Fdn+WEy33HTSn9RnPGlKGgxMb0UN5g
         IrmsIqwJGaJy1w9fUkNWWHR4T/FebXzpdn6+wsMHzIyuj5TfnWJUJR9Mk6EN8IFcBkbG
         eAFg==
X-Gm-Message-State: ANhLgQ1FY0ECMkGESgiSbtBLzrwSBJY6T/b5oXmHrwvoyhGLhtbB3aiu
        A2kQnlXD8nWDGbs3hley4bO9McwAcq23zi/l1IA=
X-Google-Smtp-Source: ADFU+vu1zu+zF1eajOarhgvTEIhC25TIaXxm6UWT6zlCVlYsJa6FVQG2VqRKcJ5ilAUAF23naZM27AkRLEVlHqscFWg=
X-Received: by 2002:a92:d702:: with SMTP id m2mr1978296iln.149.1583192409639;
 Mon, 02 Mar 2020 15:40:09 -0800 (PST)
MIME-Version: 1.0
References: <20200302232057.GA182308@google.com> <2fa00fef-7d11-d0b6-49a0-85a2b08a144d@intel.com>
In-Reply-To: <2fa00fef-7d11-d0b6-49a0-85a2b08a144d@intel.com>
Reply-To: bjorn@helgaas.com
From:   Bjorn Helgaas <bjorn.helgaas@gmail.com>
Date:   Mon, 2 Mar 2020 17:39:58 -0600
Message-ID: <CABhMZUXJ_Omt-+fwa4Oz-Ly=J+NM8+8Ryv-Ad1u_bgEpDRH7RQ@mail.gmail.com>
Subject: Re: [PATCH 1/5] pci: introduce pci_get_dsn
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Bjorn Helgaas <helgaas@kernel.org>, linux-pci@vger.kernel.org,
        netdev@vger.kernel.org, Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        QLogic-Storage-Upstream@cavium.com,
        Michael Chan <michael.chan@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 2, 2020 at 5:24 PM Jacob Keller <jacob.e.keller@intel.com> wrote:
>
> On 3/2/2020 3:20 PM, Bjorn Helgaas wrote:
> > On Mon, Mar 02, 2020 at 02:33:12PM -0800, Jacob Keller wrote:
> >> On 3/2/2020 2:25 PM, Bjorn Helgaas wrote:
> >
> >>>> +int pci_get_dsn(struct pci_dev *dev, u8 dsn[])
> >>>> +{
> >>>> +  u32 dword;
> >>>> +  int pos;
> >>>> +
> >>>> +
> >>>> +  pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_DSN);
> >>>> +  if (!pos)
> >>>> +          return -EOPNOTSUPP;
> >>>> +
> >>>> +  /*
> >>>> +   * The Device Serial Number is two dwords offset 4 bytes from the
> >>>> +   * capability position.
> >>>> +   */
> >>>> +  pos += 4;
> >>>> +  pci_read_config_dword(dev, pos, &dword);
> >>>> +  put_unaligned_le32(dword, &dsn[0]);
> >>>> +  pci_read_config_dword(dev, pos + 4, &dword);
> >>>> +  put_unaligned_le32(dword, &dsn[4]);
> >>>
> >>> Since the serial number is a 64-bit value, can we just return a u64
> >>> and let the caller worry about any alignment and byte-order issues?
> >>>
> >>> This would be the only use of asm/unaligned.h in driver/pci, and I
> >>> don't think DSN should be that special.
> >>
> >> I suppose that's fair, but it ends up leaving most callers having to fix
> >> this immediately after calling this function.
> >
> > PCIe doesn't impose any structure on the value; it just says the first
> > dword is the lower DW and the second is the upper DW.  As long as we
> > put that together correctly into a u64, I think further interpretation
> > is caller-specific.
>
> Makes sense. So basically, convert pci_get_dsn to a simply return a u64
> instead of copying to an array, and then make callers assume that a
> value of 0 is invalid?

Yep, that's what I would do.

You might have to re-jigger the snprintfs so they still pull out the
same bytes they did before.

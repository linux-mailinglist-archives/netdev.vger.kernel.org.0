Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0F4B1EA10C
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 11:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725946AbgFAJgW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 05:36:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725290AbgFAJgW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 05:36:22 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA4C2C061A0E;
        Mon,  1 Jun 2020 02:36:20 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id k19so6741551edv.9;
        Mon, 01 Jun 2020 02:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wSgsSiuHFdbWoFOMi8zHqxH+AXQ3Xi1eIriJ+02+Jwc=;
        b=nPucrLK4fIr7QcJ/7TpyNpjJSvIjZFjAbmFtgdKkgFTKASISJtTGY0FMMfa191ILq/
         ZiBLbVZYufSQb7gu4NfE7P/7NtotCKaYw3cTwLyvOsUDey8DmkdoUK4p5qwOvx8M4kSZ
         XdFSs1kSgkkRnyf1fMhyQXlB0cnWGWRC+u7ckfJ89QaOTskdrq/+alGQoQfOrTXnhLTh
         SkSWMcwJvcBhSsk2E/wSZJ+uqJvRJl8dG7iMpgDFXyw7mHgdrCXVMGbbztxUBMFh/fCA
         UYrUCjlWyWyN02Bdd283am6w/IFbuZPmwoik8xb1Npw4WvRHw2D8ocgm+7bsRbKIF3S0
         PZyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wSgsSiuHFdbWoFOMi8zHqxH+AXQ3Xi1eIriJ+02+Jwc=;
        b=uifd7s3ENHkRDN0+B3wEZeRk8SnzHIxqNKuOk4j0m/FzZeekKjRg8Wb7CQrOArZDv6
         pAhsQLXHf85Z6jPKB0TSGD/3ZuPHFrkISdlwXtioo10WViQfi7eOWM8lkJe0kA1i2dUq
         uSPeIijfv8CKzSqUkhhgBn0CLtQEbhvEoO/SyjESMZDRP7LwdoBCYTPki7cVrjYDVc9p
         xsPKgoFLTKadZBXffNT9inGInP/max8mLGRpIJJQ9myy/JUGdKsUHSbXmg0nRcdk60GY
         QW+8zI4d50Mt4CmVHZ+oFsJ+11o6L/U6EZpU76dw35o8zAxtoMw6rfbUeC8o+8IfrhIr
         fhZg==
X-Gm-Message-State: AOAM532+Y0qvn2pY0RU9l2TMrQPjLS6TPX3l0QFL0b38HQ2YWs6KFQqT
        VDnJGLRNiIGPTdBXS4l4w/rjxLgNLeNzkL7i63EGXw==
X-Google-Smtp-Source: ABdhPJwwcw4YXSscVmJIvXWcT0758Qc+D5IxyUW0q8Hkda8zyz+7inCQ8CmAzLmr9xjlWIxhzYtEtUlv5Ew4b9CR0+0=
X-Received: by 2002:a05:6402:362:: with SMTP id s2mr4227939edw.337.1591004179498;
 Mon, 01 Jun 2020 02:36:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200531180758.1426455-1-olteanv@gmail.com> <39107d25-f6e6-6670-0df6-8ae6421e7f9a@cogentembedded.com>
In-Reply-To: <39107d25-f6e6-6670-0df6-8ae6421e7f9a@cogentembedded.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 1 Jun 2020 12:36:08 +0300
Message-ID: <CA+h21hq4tah3EAdFaLdxTR1JtEaSiZfOFuinwHq-p0AZ+ENesw@mail.gmail.com>
Subject: Re: [PATCH v2] devres: keep both device name and resource name in
 pretty name
To:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        bgolaszewski@baylibre.com, mika.westerberg@linux.intel.com,
        efremov@linux.com, ztuowen@gmail.com,
        lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sergei,

On Mon, 1 Jun 2020 at 10:51, Sergei Shtylyov
<sergei.shtylyov@cogentembedded.com> wrote:
>
> Hello!
>
> On 31.05.2020 21:07, Vladimir Oltean wrote:
>
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >
> > Sometimes debugging a device is easiest using devmem on its register
> > map, and that can be seen with /proc/iomem. But some device drivers have
> > many memory regions. Take for example a networking switch. Its memory
> > map used to look like this in /proc/iomem:
> >
> > 1fc000000-1fc3fffff : pcie@1f0000000
> >    1fc000000-1fc3fffff : 0000:00:00.5
> >      1fc010000-1fc01ffff : sys
> >      1fc030000-1fc03ffff : rew
> >      1fc060000-1fc0603ff : s2
> >      1fc070000-1fc0701ff : devcpu_gcb
> >      1fc080000-1fc0800ff : qs
> >      1fc090000-1fc0900cb : ptp
> >      1fc100000-1fc10ffff : port0
> >      1fc110000-1fc11ffff : port1
> >      1fc120000-1fc12ffff : port2
> >      1fc130000-1fc13ffff : port3
> >      1fc140000-1fc14ffff : port4
> >      1fc150000-1fc15ffff : port5
> >      1fc200000-1fc21ffff : qsys
> >      1fc280000-1fc28ffff : ana
> >
> > But after the patch in Fixes: was applied, the information is now
> > presented in a much more opaque way:
> >
> > 1fc000000-1fc3fffff : pcie@1f0000000
> >    1fc000000-1fc3fffff : 0000:00:00.5
> >      1fc010000-1fc01ffff : 0000:00:00.5
> >      1fc030000-1fc03ffff : 0000:00:00.5
> >      1fc060000-1fc0603ff : 0000:00:00.5
> >      1fc070000-1fc0701ff : 0000:00:00.5
> >      1fc080000-1fc0800ff : 0000:00:00.5
> >      1fc090000-1fc0900cb : 0000:00:00.5
> >      1fc100000-1fc10ffff : 0000:00:00.5
> >      1fc110000-1fc11ffff : 0000:00:00.5
> >      1fc120000-1fc12ffff : 0000:00:00.5
> >      1fc130000-1fc13ffff : 0000:00:00.5
> >      1fc140000-1fc14ffff : 0000:00:00.5
> >      1fc150000-1fc15ffff : 0000:00:00.5
> >      1fc200000-1fc21ffff : 0000:00:00.5
> >      1fc280000-1fc28ffff : 0000:00:00.5
> >
> > That patch made a fair comment that /proc/iomem might be confusing when
> > it shows resources without an associated device, but we can do better
> > than just hide the resource name altogether. Namely, we can print the
> > device name _and_ the resource name. Like this:
> >
> > 1fc000000-1fc3fffff : pcie@1f0000000
> >    1fc000000-1fc3fffff : 0000:00:00.5
> >      1fc010000-1fc01ffff : 0000:00:00.5 sys
> >      1fc030000-1fc03ffff : 0000:00:00.5 rew
> >      1fc060000-1fc0603ff : 0000:00:00.5 s2
> >      1fc070000-1fc0701ff : 0000:00:00.5 devcpu_gcb
> >      1fc080000-1fc0800ff : 0000:00:00.5 qs
> >      1fc090000-1fc0900cb : 0000:00:00.5 ptp
> >      1fc100000-1fc10ffff : 0000:00:00.5 port0
> >      1fc110000-1fc11ffff : 0000:00:00.5 port1
> >      1fc120000-1fc12ffff : 0000:00:00.5 port2
> >      1fc130000-1fc13ffff : 0000:00:00.5 port3
> >      1fc140000-1fc14ffff : 0000:00:00.5 port4
> >      1fc150000-1fc15ffff : 0000:00:00.5 port5
> >      1fc200000-1fc21ffff : 0000:00:00.5 qsys
> >      1fc280000-1fc28ffff : 0000:00:00.5 ana
> >
> > Fixes: 8d84b18f5678 ("devres: always use dev_name() in devm_ioremap_resource()")
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> [...]
>
>     You didn't write the version log -- what changed since v1?
>
> MBR, Sergei

The changes in v2 are that I'm checking for memory allocation errors.

Thanks,
-Vladimir

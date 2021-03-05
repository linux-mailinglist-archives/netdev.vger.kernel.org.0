Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF1932F703
	for <lists+netdev@lfdr.de>; Sat,  6 Mar 2021 00:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbhCEX6h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 18:58:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbhCEX6I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 18:58:08 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EFEBC06175F
        for <netdev@vger.kernel.org>; Fri,  5 Mar 2021 15:58:08 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id j6-20020a17090adc86b02900cbfe6f2c96so4581pjv.1
        for <netdev@vger.kernel.org>; Fri, 05 Mar 2021 15:58:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=R2Rq+GxaR0K87NR2obpITQXD3r5qv5hkMlSA6mxVodA=;
        b=j1MpeuGdVdkQa2XuuMsnp7DMhg7BGzx192DkVWB2OiEQGSyYoKQb69p/ypDmBZfKvp
         kGyGfyeQdJstIIliyg0JP4gRRhVvDgL2sUeIRxrzgKoZ70eyZ6aXIGmRbSJ6NNuJmYjY
         bhGNtFBOz42jr0BQzYEgranV6PEDslvFhXPkMEPZ70t8nnygc250BC2qmsST0Sbkg5yu
         krkqyqeskvh1NIWXpKi2cDPisVgBUaLokKTbhfWm6qPySDkuW0iI64nWfIzwnneeFLBX
         ibhgfq1kg91BcK+lnbgdJxUeH/KXvE4PSxylwSrVtz3sLk5qzWsiV02dnm+LE/HGUxTc
         3I/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=R2Rq+GxaR0K87NR2obpITQXD3r5qv5hkMlSA6mxVodA=;
        b=GGVODwnV2fnC38GX48EM1lxa+refh4NTjH28qkTJ7PSxhQvvOaIhpAMCwopoi2cpr6
         qMHbRqEnUyc7WTZwMx8O/PY9R5J2XXSFdO98T28MZDkeNn33YTc/uYAdrWuBXO2TZn85
         OAvOLCnBGRo8syyURKW9L1knsCDwX09Uf8/0UDnKBHwpyxipWVcSQ3HW8zlehk3Jnhga
         YWV8CrVGHpOhypDLekcme/znp8jbaSVwZw2LN/9yVaw0Q2WfJvUwIDy//UPrkygB1Yi4
         1UG6rvA9OmTBUqoZPkf4ZNqgXFuSBpIu6i6VZi5wAHhXERZObo89SYdrBgAu4ft1CsIM
         MZNQ==
X-Gm-Message-State: AOAM533TyEXVlujBDtvkx2z5yJTRQnahFBOQtT6ltgwfXYXATy4xBhVX
        0mHLSHxVIkHKZ1xWZmIxbYiFB0vyxo0cJ/skUjEydtFmO94qJA==
X-Google-Smtp-Source: ABdhPJyVBFyJW8/eWAFnVcJ6l76KcB7yeWSZqMTgOSl4ydZo0iyUDCla+W54Fbxa+7GvT2YJit11Lt0MJDmYBEYikBk=
X-Received: by 2002:a17:902:e80e:b029:e4:b2b8:e36e with SMTP id
 u14-20020a170902e80eb02900e4b2b8e36emr10714374plg.45.1614988687669; Fri, 05
 Mar 2021 15:58:07 -0800 (PST)
MIME-Version: 1.0
References: <CADbyt64e2cmQzZTEg3VoY6py=1pAqkLDRw+mniRdr9Rua5XtgQ@mail.gmail.com>
 <a47aac93-d528-beee-a2a7-ce4b12c718b9@gmail.com>
In-Reply-To: <a47aac93-d528-beee-a2a7-ce4b12c718b9@gmail.com>
From:   Greesha Mikhalkin <grigoriymikhalkin@gmail.com>
Date:   Sat, 6 Mar 2021 00:57:56 +0100
Message-ID: <CADbyt65AfRCnyM06nZGZphg=YdLEE0UqUDT7+uA3HUt90sGKZQ@mail.gmail.com>
Subject: Re: VRF leaking doesn't work
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David!

Thanks for your answer. Currently kernel version that i use is
5.4.0-54-generic. I tried to upgrade to 5.11.3-051103-generic but that
didn't help.

=D0=BF=D1=82, 5 =D0=BC=D0=B0=D1=80. 2021 =D0=B3. =D0=B2 16:37, David Ahern =
<dsahern@gmail.com>:
>
> What kernel version? If you have not tried 5.10 or 5.11, please do.

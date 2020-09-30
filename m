Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69CD727EA2D
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 15:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730220AbgI3NoP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 09:44:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728235AbgI3NoP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 09:44:15 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6068C0613D0
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 06:44:14 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id u21so2922784eja.2
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 06:44:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Uv+0SEm3ZBbuCilDEG/CT4tZmdLu+h9w/O+Bpd1VJEw=;
        b=kZXhuwkp+0Pj2nq+Wdm8mrhdY9dD6koq1af5Fk5s6iJWJreLo6FGGg++D7B+iF2Z16
         Gc9IuJzNwpLIbJBk14f/+KcHO4zb07BLd3JdWWZ/6Sq53QRfNWGgZnNYraOqYw+NaV/S
         Oa52DvX7NZE2OAQai8XFn19vQRqJ7DZCWAYCPzunUkclSon5s8WuKyspntOGXBUGi+kM
         gSQSDp6Ih1tOXtz8Jfo8XC+2RHN6ucdjBH/ZZAh5bB8x9kBEAQie6wWnc+SvOSu9cFkb
         00sAviQPAdrFOZOxV0PZQ7ktzrj1OS69sEMG7wsu9RcsJSPo9XGLG0Ver4XX44A5fflG
         WC8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Uv+0SEm3ZBbuCilDEG/CT4tZmdLu+h9w/O+Bpd1VJEw=;
        b=ctFQWm16Ker0XzzoJ09QRigm0YJlK/s5MSi/t8TE7Cv0pwxQr2hhn/L0T4FEJYuRK8
         8RcXhxcBPYofu+/KEtarIZC5SQTP9S8WJERVn70tS4TBfIczyLl3wEMjNCdx4TW7RGb0
         Fa0jqlxb5xaYsIky5kk6hMXx7GygZ1qhKkDO5Fh7Kjiv2eRItlw/EYyMNotwCifMPBF/
         rrayXWJZzouGr+oCsLY5khO89k1RVWkrhbMluBSb7493KEaa2KfPH0CbsZM4zzY43Yn2
         DTrwmg9UPFntv/y4SLzteJWPM6EyROIkRaUJnJs/N5gHf3GYGvFczgRYQ3+mkNg4wabJ
         DU7A==
X-Gm-Message-State: AOAM5315o+XFKJlM61PyCa8Sr5Ir5APIykcHpVVv73i2qmL/quxN/TkH
        SzZubhcQ+jxtbU7TdjjKs0fMlQ4Se7bbt0ENBnC9
X-Google-Smtp-Source: ABdhPJyIyHapkdpsMZlH1k0VMzFpSD2bBOeAOJPN9zjb137yZwO+lFN8UEOnqZPlBqsUFSYFjZaRiRi8PRSDcuT8Xyg=
X-Received: by 2002:a17:906:77cd:: with SMTP id m13mr2817282ejn.106.1601473453339;
 Wed, 30 Sep 2020 06:44:13 -0700 (PDT)
MIME-Version: 1.0
References: <160141647786.7997.5490924406329369782.stgit@sifl> <alpine.LRH.2.21.2009300909150.6592@namei.org>
In-Reply-To: <alpine.LRH.2.21.2009300909150.6592@namei.org>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 30 Sep 2020 09:44:02 -0400
Message-ID: <CAHC9VhTM_a+L8nY8QLVdA1FcL8hjdV1ZNLJcr6G_Q27qPD_5EQ@mail.gmail.com>
Subject: Re: [RFC PATCH] lsm,selinux: pass the family information along with
 xfrm flow
To:     James Morris <jmorris@namei.org>
Cc:     selinux@vger.kernel.org, linux-security-module@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 7:09 PM James Morris <jmorris@namei.org> wrote:
> I'm not keen on adding a parameter which nobody is using. Perhaps a note
> in the header instead?

On Wed, Sep 30, 2020 at 6:14 AM Herbert Xu <herbert@gondor.apana.org.au> wrote:
> Please at least change to the struct flowi to flowi_common if we're
> not adding a family field.

It did feel a bit weird adding a (currently) unused parameter, so I
can understand the concern, I just worry that a comment in the code
will be easily overlooked.  I also thought about passing a pointer to
the nested flowi_common struct, but it doesn't appear that this is
done anywhere else in the stack so it felt wrong to do it here.

-- 
paul moore
www.paul-moore.com

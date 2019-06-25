Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15A57559CE
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 23:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726223AbfFYVTu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 17:19:50 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:43319 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725290AbfFYVTu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 17:19:50 -0400
Received: by mail-pl1-f195.google.com with SMTP id cl9so119240plb.10
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 14:19:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=318/F64MRVThD6drKvp6v4JpYRMrYpBkhrwSZcHYF8g=;
        b=U17DEEigSUf+CD2yF2mdyA5DgVlbqsasZHiDw0pR5K2+kgyzPgRBt3UpRLTcziJXia
         IKMSJ7A54jQz2SVVSEctjU/LE+IB/qTrA1X7zFnVKAT4VUCImIUb5WxMrWteKf9kJFqC
         MAX8kK5dGct+kdvxS5nYVgcR3lX9pxVnZt6+zutB4Yj2Re3uzNGGMajKlFHaNBC+w+yP
         mH4WJ6EoOE0SX0I5AXYVs61vmVxxKCmOe+bzfDpKPjgBvUmgOwD813mVUGU0dBAYJ6uV
         fLWZv9PkeoLhrGlZ8Cy3yBVFcsrQFb03RNYa7aVBGX0p6w9uTmwimeLLWRq8/UAetELO
         fO0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=318/F64MRVThD6drKvp6v4JpYRMrYpBkhrwSZcHYF8g=;
        b=jnSXoT3LjOpaFlzN0tVRKhGsJg2sjWKsi+/R9hqnutNQUarP0SiE4Pcpn8Js1Sa4eJ
         F+jEt7bv9fmtOLfTgqDIxL8/L/7+GAQ1wRYa8moeBIjjKejhPAh/2T/+cTrvempsBXSV
         q4IWIIgmG0ZupjJbv9oi4lqruG/wYcwj7exy3Kvlx5X+k1/deyoxUA5K4qpC118aJ/Qy
         Ot7CqhqpzEKJF/qyZempZNj5xRGNIv1SfeDx6v3Dk6euxRHdHxIzr7hTnfQv1EM+PxBI
         j6uQFMwaZ7NqfPtHpj1JU6KEKT/qOijUrOXVp8e55TJffxpckcl4OrpAh5sSM9/izQns
         ey4w==
X-Gm-Message-State: APjAAAVcHVGdBMI/Qhkns/Qi7+59S587jTbOG06YvvIcDmAm1XCkpR+t
        p9nDOFDuT7D3mOP6Ml9Nr+XmqA==
X-Google-Smtp-Source: APXvYqw7jLksEyjREhJ+ZuyrcdebDQn94Ed7i5dIPE6ifnX4os+NPpskM24MHLU7YKqaFzarMy7vDg==
X-Received: by 2002:a17:902:76c3:: with SMTP id j3mr851172plt.116.1561497589998;
        Tue, 25 Jun 2019 14:19:49 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id z20sm29887527pfk.72.2019.06.25.14.19.49
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 14:19:49 -0700 (PDT)
Date:   Tue, 25 Jun 2019 14:19:48 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Alexei Starovoitov <ast@fb.com>
Cc:     Song Liu <songliubraving@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 0/4] sys_bpf() access control via /dev/bpf
Message-ID: <20190625211948.GE10487@mini-arch>
References: <20190625182303.874270-1-songliubraving@fb.com>
 <20190625205155.GD10487@mini-arch>
 <59e56064-354c-d6b9-101a-c698976e6723@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <59e56064-354c-d6b9-101a-c698976e6723@fb.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/25, Alexei Starovoitov wrote:
> On 6/25/19 1:51 PM, Stanislav Fomichev wrote:
> > On 06/25, Song Liu wrote:
> >> Currently, most access to sys_bpf() is limited to root. However, there are
> >> use cases that would benefit from non-privileged use of sys_bpf(), e.g.
> >> systemd.
> >>
> >> This set introduces a new model to control the access to sys_bpf(). A
> >> special device, /dev/bpf, is introduced to manage access to sys_bpf().
> >> Users with access to open /dev/bpf will be able to access most of
> >> sys_bpf() features. The use can get access to sys_bpf() by opening /dev/bpf
> >> and use ioctl to get/put permission.
> >>
> >> The permission to access sys_bpf() is marked by bit TASK_BPF_FLAG_PERMITTED
> >> in task_struct. During fork(), child will not inherit this bit.
> > 2c: if we are going to have an fd, I'd vote for a proper fd based access
> > checks instead of a per-task flag, so we can do:
> > 	ioctl(fd, BPF_MAP_CREATE, uattr, sizeof(uattr))
> > 
> > (and pass this fd around)
> > 
> > I do understand that it breaks current assumptions that libbpf has,
> > but maybe we can extend _xattr variants to accept optinal fd (and try
> > to fallback to sysctl if it's absent/not working)?
> 
> both of these ideas were discussed at lsfmm where you were present.
> I'm not sure why you're bring it up again?
Did we actually settle on anything? In that case feel free to ignore me,
maybe I missed that. I remember there were pros/cons for both implementations.

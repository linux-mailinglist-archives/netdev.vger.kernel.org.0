Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4A211988F7
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 02:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729640AbgCaAii (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 20:38:38 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:44013 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729372AbgCaAii (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 20:38:38 -0400
Received: by mail-pl1-f196.google.com with SMTP id v23so7431356ply.10;
        Mon, 30 Mar 2020 17:38:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+WIg18odYCSh3MbJQvov8y3l/e6uIQfx3wUGGy/3rtg=;
        b=EuefBLq52IV3IGZnWyxgtYs8Okz0wZEHDKJ4XicCDxi96ZvkeNaVOqVIRwUPEnZrCQ
         rqYI7U1yIf/If+8s6JunpJaT1h/uSS6yRGHrW6tFciKhB3kqukUU4XiqskzFCz6DW6Ho
         o23yVQhQo3JDq3maF23tmc99d3yy6pUGilUdVWar+gpVOcDs3GQ9ZuvHsivvKpL7zXvL
         ZswpCVtuzRsa5cQrJ4jOzufbYyjsSRIU7YMrIoeWczVTOaY5i/5GL1IC/6+QfnvHTb6e
         gS1cbP2lRf6BKxOlbBfihv1Uj43HjDklOAgjsFNXpiXG8KIuBfPJU5HHQe5NaQFJxpi0
         IceQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+WIg18odYCSh3MbJQvov8y3l/e6uIQfx3wUGGy/3rtg=;
        b=OcUH9tsATtI9Wi8Q/kWPtjCzFnxZ3iJ4NOn+7Xu2byUSa5AZTpPxvoA03wbSnEOvxY
         zmUmJzTwy9RTxmvouWYiYqqlJi3pSTQ/Zn3IhKk6M1afkewKjLVxJ42hjIp/DCRDhBRE
         8f798KPKFOSblYBaXcerVdPEwpp/CGoVw7yEoUh1yO35QZ0gPoWfGssw2K9fpfCglJnt
         PhOsFqmkbgtgwBapjF5NJnHWJdzHVz5SAK9qbgPzyUc3j3HqmtvWruIWXvwS6jiCgHWJ
         4a1uf4nJhEGOe0K5n/GU1045Kk80hInlAxpDv6lreD5591NRGVv4so/MOqPpyigjHbrb
         +C/A==
X-Gm-Message-State: AGi0Pubf9YRPq5K5KzI2FMx89cTovwdKoiw8/WcBdpCKEWqu9OVAOX77
        G4H+b7EcYd2B+Ma1bnZLYjc=
X-Google-Smtp-Source: APiQypLavlSpVay52TQP75yPO7l+XdDdm2k8l2Puvv5/oE6wdv2bQZaABDA1m9Jxvl/bY+lzmrT/TQ==
X-Received: by 2002:a17:902:7046:: with SMTP id h6mr9813349plt.250.1585615116816;
        Mon, 30 Mar 2020 17:38:36 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:3558])
        by smtp.gmail.com with ESMTPSA id b25sm10960877pfd.185.2020.03.30.17.38.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2020 17:38:35 -0700 (PDT)
Date:   Mon, 30 Mar 2020 17:38:33 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrey Ignatov <rdna@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net,
        andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH v3 bpf-next 1/4] bpf: implement bpf_link-based cgroup BPF
 program attachment
Message-ID: <20200331003833.2cimhnn5scfroyv7@ast-mbp>
References: <20200330030001.2312810-1-andriin@fb.com>
 <20200330030001.2312810-2-andriin@fb.com>
 <20200331000513.GA54465@rdna-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200331000513.GA54465@rdna-mbp.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 30, 2020 at 05:05:13PM -0700, Andrey Ignatov wrote:
> >  
> > +#define BPF_LINK_CREATE_LAST_FIELD link_create.flags
> > +static int link_create(union bpf_attr *attr)
> > +{
> 
> From what I see this function does not check any capability whether the
> existing bpf_prog_attach() checks for CAP_NET_ADMIN.

Great catch! It's a bug.
I fixed it up.

> This is pretty importnant difference but I don't see it clarified in the
> commit message or discussed (or I missed it?).
> 
> Having a way to attach cgroup bpf prog by non-priv users is actually
> helpful in some use-cases, e.g. systemd required patching in the past to
> make it work with user (non-priv) sessions, see [0].
> 
> But in other cases it's also useful to limit the ability to attach
> programs to a cgroup while using bpf_link so that only the thing that
> controls cgroup setup can attach but not any non-priv process running in
> that cgroup. How is this use-case covered in BPF_LINK_CREATE?
> 
> 
> [0] https://github.com/systemd/systemd/pull/12745

yeah. we need to resurrect the discussion around CAP_BPF.

PS
pls trim your replies.

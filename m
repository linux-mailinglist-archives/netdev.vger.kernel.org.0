Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07EFF91121
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 17:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbfHQPIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 11:08:49 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:37582 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbfHQPIt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Aug 2019 11:08:49 -0400
Received: by mail-pf1-f195.google.com with SMTP id 129so4657979pfa.4;
        Sat, 17 Aug 2019 08:08:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zaQgiRUD9bFkoEC1MQ4ZPR5U0C+wFe97EOGkru/Ez+Q=;
        b=gd/ED5nxe2vMcfWakfzqthJBQjXfRtJoSVWDgay7rfDRtCWAFNLn1aFRDkS7qN+KbS
         aeohdwXzXwEbUkLCeyF3dXUA8JX4PAwQQb3pYyyVhJL674IKp1DhvXxaPXLRowPNQ/mN
         2nn85HLfe/QPxCvWPpDH892YNOMcWuHK+lNL4pAenjGwJBikmBIozwm93eTtIj1uSsjp
         99FiCDL9nZKZtj9ExnUzJxOfLJQZO67CeJ/U4GzqDKzt/uDaxLg6Wxh0w3tZTybD+cEd
         wN9jEQVThzY78lM8zZmlEvplKKD1M/uzIF9igr1U83Nb866QgHMZ3726/fbEVlDyguCr
         BSjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=zaQgiRUD9bFkoEC1MQ4ZPR5U0C+wFe97EOGkru/Ez+Q=;
        b=EL6PSjsniboC+l57ksij1GdRnR5eySCUC9Qy04Vgm22aYTuGe6s1kv5YiRgceZA2JZ
         SVkSD4VgSdGbLUrvn02h/0AORUT+Sc8FAKyS5olKyUx9ZbgtbbVM1HwIMHHfLVDFR+kz
         42tQgWiNQ4RN8kk5NqmOql45sOJpwsm+JRsBRkqXj1uMCkVrgL6IsLCmHP0y+jdlQgng
         Flm+DJd2LjPXdmYgS46Oa0E1k/T7JjogI01p63EGgObjDw2dnfvdLlhoj0eslnuCuZmu
         PRgLX1RjzfFkIllYsOHXyhYRIik4r1ZG1Thu7G3aGht11BewNBWfbmiYOEh4nyusOHJG
         5epw==
X-Gm-Message-State: APjAAAUb0/cMkj7RUvY3acZv4WJmJAwuboN4PnwI8Jll1heanX8T3xeN
        8xoxaf429z6t/3tfhwNsa30=
X-Google-Smtp-Source: APXvYqxNi0TMs1XBwGfOkiBJbZo3XNJ/UeEkVQKQDxW9/G2zNrG5CjnaXyOqsEFhbuM4akleUX3wfQ==
X-Received: by 2002:a17:90a:5207:: with SMTP id v7mr11854148pjh.127.1566054528053;
        Sat, 17 Aug 2019 08:08:48 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:180::9c96])
        by smtp.gmail.com with ESMTPSA id w11sm10440881pfi.105.2019.08.17.08.08.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 17 Aug 2019 08:08:47 -0700 (PDT)
Date:   Sat, 17 Aug 2019 08:08:45 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        Kees Cook <keescook@chromium.org>,
        Andy Lutomirski <luto@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jann Horn <jannh@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
Message-ID: <20190817150843.4vsmzpwpcvzndjld@ast-mbp>
References: <20190805192122.laxcaz75k4vxdspn@ast-mbp>
 <CALCETrVtPs8gY-H4gmzSqPboid3CB++n50SvYd6RU9YVde_-Ow@mail.gmail.com>
 <20190806011134.p5baub5l3t5fkmou@ast-mbp>
 <CALCETrXEHL3+NAY6P6vUj7Pvd9ZpZsYC6VCLXOaNxb90a_POGw@mail.gmail.com>
 <20190813215823.3sfbakzzjjykyng2@ast-mbp>
 <201908151203.FE87970@keescook>
 <20190815234622.t65oxm5mtfzy6fhg@ast-mbp.dhcp.thefacebook.com>
 <B0364660-AD6A-4E5C-B04F-3B6DA78B4BBE@amacapital.net>
 <20190816214542.inpt6p655whc2ejw@ast-mbp.dhcp.thefacebook.com>
 <20190816222252.a7zizw7azkxnv3ot@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190816222252.a7zizw7azkxnv3ot@wittgenstein>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 17, 2019 at 12:22:53AM +0200, Christian Brauner wrote:
> 
> (The one usecase I'd care about is to extend seccomp to do pointer-based
> syscall filtering. Whether or not that'd require (unprivileged) ebpf is
> up for discussion at KSummit.)

Kees have been always against using ebpf in seccomp. I believe he still
holds this opinion. Until he changes his mind let's stop bringing seccomp
as a use case for unpriv bpf.


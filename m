Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E11BCE0A5
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 13:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727656AbfJGLht (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 07:37:49 -0400
Received: from mail-yb1-f196.google.com ([209.85.219.196]:44026 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727394AbfJGLht (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 07:37:49 -0400
Received: by mail-yb1-f196.google.com with SMTP id y204so4526510yby.10
        for <netdev@vger.kernel.org>; Mon, 07 Oct 2019 04:37:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u2b4etbFaErKVKdWfzWpQ1nnVAB/SWDEa/HWfiX0Kls=;
        b=k/5/IYFt00un+pALL1yQLhClew0FJjKAWPMBB8k0CdonNK5WnUsW+f7dyLN8M03Z5G
         oqzz3uMl5XFk4epuKbGT6RCX192ypcuDPuHj9cgi0Cx9MumTf7g46eKDQI2YH6Tmd8iX
         rr6g4Hqo7WsHyJlIwJ8iqhH6tsMHYtxH0xhXyNwMgozvHozYDj58pq5BS7BwCQvOmoqL
         rNPpyqmbp5wJW6WHi++9CGmnha7a6HnKD2OYUjlwLm6cC/zMzP24ENLa1S2Fctsxd4QL
         7ksA0Nqclq2nWY9f1DY6AmVgxJiZEvoYOL+rp9lOgWYg/DPgbI/NlaSNkNvQvige3JJY
         s4zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u2b4etbFaErKVKdWfzWpQ1nnVAB/SWDEa/HWfiX0Kls=;
        b=Uo67ffaHEW8djg854gTeCiWEj9qBthLtK1X/JHt2NU6yKSysFzBzg5nl8phscup9Gj
         KIS03kM8jJgmPY6pqnUKQRBNMm7Byiy6DSHhTEXRSIbwp60/ootX7whkBw0mAVzigYIi
         YCqz9c7++k4yt9ZnJ7eJll3iO6ZLl68Vgsouad2Expqus4kJyrx9TuOjqbTMyZCiDuAu
         Wcv0jW6rMetlaokh+aOnINXL9kzDSKqCHzYXqoXdeTkk5bnXmUBh90PURz412/iXsBdY
         WySOX78cOcGEvGwUiPFK2p9rkrhdrkSsMnt4zCvgf924cRzXqyqRwubFfSd4JyiwHhGv
         aA9A==
X-Gm-Message-State: APjAAAVcs1C3aJk09aanLx8FBMcEQYdUA6D0nz7IYeBQYx4V2UwEEBtR
        4M6wPXv8y4YWgKN0CG18yEmp7sVjtyZhTfu6eA==
X-Google-Smtp-Source: APXvYqwOnhR6to8Va0Pur2F3VCnGV+827nLi53gPacpQzUFcNdtuRUz0BFyYP1uEJfZ/hxBtsBKgs8Tm3Zg5ogq6FDk=
X-Received: by 2002:a25:c009:: with SMTP id c9mr10966413ybf.164.1570448268030;
 Mon, 07 Oct 2019 04:37:48 -0700 (PDT)
MIME-Version: 1.0
References: <20191005082509.16137-1-danieltimlee@gmail.com>
 <20191005082509.16137-3-danieltimlee@gmail.com> <20191007101537.24c1961c@carbon>
In-Reply-To: <20191007101537.24c1961c@carbon>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Mon, 7 Oct 2019 20:37:31 +0900
Message-ID: <CAEKGpziOQ3PYeibyBK0pj6ZHhVyGsOahUHmXPC8zQYyV67mvqA@mail.gmail.com>
Subject: Re: [PATCH net-next v5 2/4] samples: pktgen: fix proc_cmd command
 result check logic
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 7, 2019 at 5:15 PM Jesper Dangaard Brouer <brouer@redhat.com> wrote:
>
> On Sat,  5 Oct 2019 17:25:07 +0900
> "Daniel T. Lee" <danieltimlee@gmail.com> wrote:
>
> > Currently, proc_cmd is used to dispatch command to 'pg_ctrl', 'pg_thread',
> > 'pg_set'. proc_cmd is designed to check command result with grep the
> > "Result:", but this might fail since this string is only shown in
> > 'pg_thread' and 'pg_set'.
> >
> > This commit fixes this logic by grep-ing the "Result:" string only when
> > the command is not for 'pg_ctrl'.
> >
> > For clarity of an execution flow, 'errexit' flag has been set.
> >
> > To cleanup pktgen on exit, trap has been added for EXIT signal.
> >
> > Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> > ---
>
> Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
>
> > Changes since v5:
> >  * when script runs sudo, run 'pg_ctrl "reset"' on EXIT with trap
> >
> >  samples/pktgen/functions.sh | 17 +++++++++++------
> >  1 file changed, 11 insertions(+), 6 deletions(-)
> >
> > diff --git a/samples/pktgen/functions.sh b/samples/pktgen/functions.sh
> > index 4af4046d71be..40873a5d1461 100644
> > --- a/samples/pktgen/functions.sh
> > +++ b/samples/pktgen/functions.sh
> > @@ -5,6 +5,8 @@
> >  # Author: Jesper Dangaaard Brouer
> >  # License: GPL
> >
> > +set -o errexit
> > +
> >  ## -- General shell logging cmds --
> >  function err() {
> >      local exitcode=$1
> > @@ -58,6 +60,7 @@ function pg_set() {
> >  function proc_cmd() {
> >      local result
> >      local proc_file=$1
> > +    local status=0
> >      # after shift, the remaining args are contained in $@
> >      shift
> >      local proc_ctrl=${PROC_DIR}/$proc_file
> > @@ -73,13 +76,13 @@ function proc_cmd() {
> >       echo "cmd: $@ > $proc_ctrl"
> >      fi
> >      # Quoting of "$@" is important for space expansion
> > -    echo "$@" > "$proc_ctrl"
> > -    local status=$?
> > +    echo "$@" > "$proc_ctrl" || status=$?
> >
> > -    result=$(grep "Result: OK:" $proc_ctrl)
> > -    # Due to pgctrl, cannot use exit code $? from grep
> > -    if [[ "$result" == "" ]]; then
> > -     grep "Result:" $proc_ctrl >&2
> > +    if [[ "$proc_file" != "pgctrl" ]]; then
> > +        result=$(grep "Result: OK:" $proc_ctrl) || true
> > +        if [[ "$result" == "" ]]; then
> > +            grep "Result:" $proc_ctrl >&2
> > +        fi
> >      fi
> >      if (( $status != 0 )); then
> >       err 5 "Write error($status) occurred cmd: \"$@ > $proc_ctrl\""
> > @@ -105,6 +108,8 @@ function pgset() {
> >      fi
> >  }
> >
> > +[[ $EUID -eq 0 ]] && trap 'pg_ctrl "reset"' EXIT
> > +
>
> This is fine, but you could have placed the 'trap' handler in
> parameters.sh file, as all scripts first source functions.sh and then
> call root_check_run_with_sudo, before sourcing parameters.sh.
>

Yes, this will work since 'parameters.sh' is only sourced when it is
on root, but I've thought this file only focuses on parsing parameters
not the general workflow of the pktgen script.

So I thought 'functions.sh' is more suitable place to add trap rather
than 'paramters.sh'.

What do you think?

Thanks for the review.

Thanks,
Daniel

> >  ## -- General shell tricks --
> >
> >  function root_check_run_with_sudo() {
>
>
>
> --
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer

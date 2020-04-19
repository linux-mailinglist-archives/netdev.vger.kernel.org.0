Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65EF81AF8C6
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 10:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725923AbgDSIel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 04:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725446AbgDSIel (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 04:34:41 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5655C061A0C
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 01:34:40 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id k1so8153505wrx.4
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 01:34:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GuuuTyLHjmWjGWIaI0nRYx8ji1o1Ew/cZE5OKFV0IMA=;
        b=P49O+oB84zQ71RDkaJFHmpL/iC6rXQG1g5d4t+a1WgJu5bR0k/zuEvhHxJrY9Dh+sg
         U3mHBjqpWj95eOhEay+SK3hu4le5gXtRT65Mxd1LLy9qFU6/BBHGspEbgn1Hr0sawiMT
         9mVBzGoevlyooDquiWQvTYf/ZN9dpPTaeEwUnShs3bER26pIyhL5ePQCM+e6gsxdI0/n
         PI56SrlVv4B/d4KTXn45MTJm0jOECiO62XYvd9KuqsRDS3T9VQFE5i1DRMTYi3c5w8aq
         fSqQC0TUHMCOdq8O//0TF1JqtlodLoaaV/2KQPRAozBJ0p7pLg2gkXSs18Ui9BdDEa8R
         1b0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GuuuTyLHjmWjGWIaI0nRYx8ji1o1Ew/cZE5OKFV0IMA=;
        b=oNVRy4hPquygI9x3Gemk+p6Yz7w17Uena8eOlUYpsAvYOoRpm3XoeF/WTx6ylpEGo0
         1TW3uIx6maWarFD+TSYVc6RZWasWCUG+Mpugf1B+gyy8NrCmLCA56rqNz2WOfxhHhDAj
         V9b5zIoivbmHw8AR5aZageFL9HWBv28M74t+Qe4CiByHpNyVrVhxuEwc9fbw4OLElX6e
         SOVOHwYWSx2jLngJiCWLwjQfOCFF0C31yHlfFVVNUBREQvXX/T23FfleRlU6a9BCTKEH
         IJNpyW3vAY/v4+LOEjU6jMQNwFV3JiLJZIwAJkBq2e5rLMFhReiBM25wuYmUZOlPw5Vn
         Kr5A==
X-Gm-Message-State: AGi0PuYuRZzpaiweMv8X7OaXg6Wmgx6HVj3WxZnph1NjTRLBhsKiywGp
        f/3P5YcLYbVE2vNd3U83/5bv01VgkGIMjnrMjvOLfRZA
X-Google-Smtp-Source: APiQypLPYTRI1jK/NOsHs6dD2WQxc5ViDgu/ksW+5+ngOq9b3ePCPR0gi3BSUxM2mcLodpO3bxkCJHLe2+n9qbIe4XM=
X-Received: by 2002:a5d:6107:: with SMTP id v7mr12109099wrt.270.1587285279144;
 Sun, 19 Apr 2020 01:34:39 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1581676056.git.lucien.xin@gmail.com> <44db73e423003e95740f831e1d16a4043bb75034.1581676056.git.lucien.xin@gmail.com>
 <77f68795aeb3faeaf76078be9311fded7f716ea5.1581676056.git.lucien.xin@gmail.com>
 <290ab5d2dc06b183159d293ab216962a3cc0df6d.1581676056.git.lucien.xin@gmail.com>
 <20200214081324.48dc2090@hermes.lan> <CADvbK_dYwQ6LTuNPfGjdZPkFbrV2_vrX7OL7q3oR9830Mb8NcQ@mail.gmail.com>
 <20200214162104.04e0bb71@hermes.lan> <CADvbK_eSiGXuZqHAdQTJugLa7mNUkuQTDmcuVYMHO=1VB+Cs8w@mail.gmail.com>
 <793b8ff4-c04a-f962-f54f-3eae87a42963@gmail.com> <CADvbK_fOfEC0kG8wY_xbg_Yj4t=Y1oRKxo4h5CsYxN6Keo9YBQ@mail.gmail.com>
 <d0ec991a-77fc-84dd-b4cc-9ae649f7a0ac@gmail.com> <20200217130255.06644553@hermes.lan>
 <CADvbK_c4=FesEqfjLxtCf712e3_1aLJYv9ebkomWYs+J=vcLpg@mail.gmail.com>
In-Reply-To: <CADvbK_c4=FesEqfjLxtCf712e3_1aLJYv9ebkomWYs+J=vcLpg@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Sun, 19 Apr 2020 16:39:20 +0800
Message-ID: <CADvbK_fYTaCYgyiMog4RohJxYqp=B+HAj1H8aVKuEp6gPCPNXA@mail.gmail.com>
Subject: Re: [PATCHv3 iproute2-next 3/7] iproute_lwtunnel: add options support
 for erspan metadata
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     David Ahern <dsahern@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        Simon Horman <simon.horman@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 18, 2020 at 12:29 PM Xin Long <lucien.xin@gmail.com> wrote:
>
> On Tue, Feb 18, 2020 at 5:03 AM Stephen Hemminger
> <stephen@networkplumber.org> wrote:
> >
> > On Mon, 17 Feb 2020 12:53:14 -0700
> > David Ahern <dsahern@gmail.com> wrote:
> >
> > > On 2/15/20 11:38 PM, Xin Long wrote:
> > > > On Sun, Feb 16, 2020 at 12:51 AM David Ahern <dsahern@gmail.com> wrote:
> > > >>
> > > >> On 2/14/20 9:18 PM, Xin Long wrote:
> > > >>> On Sat, Feb 15, 2020 at 8:21 AM Stephen Hemminger
> > > >>> <stephen@networkplumber.org> wrote:
> > > >>>>
> > > >>>> On Sat, 15 Feb 2020 01:40:27 +0800
> > > >>>> Xin Long <lucien.xin@gmail.com> wrote:
> > > >>>>
> > > >>>>> This's not gonna work. as the output will be:
> > > >>>>> {"ver":"0x2","idx":"0","dir":"0x1","hwid":"0x2"}  (string)
> > > >>>>> instead of
> > > >>>>> {"ver":2,"index":0,"dir":1,"hwid":2} (number)
> > > >>>>
> > > >>>> JSON is typeless. Lots of values are already printed in hex
> > > >>> You may mean JSON data itself is typeless.
> > > >>> But JSON objects are typed when parsing JSON data, which includes
> > > >>> string, number, array, boolean. So it matters how to define the
> > > >>> members' 'type' in JSON data.
> > > >>>
> > > >>> For example, in python's 'json' module:
> > > >>>
> > > >>> #!/usr/bin/python2
> > > >>> import json
> > > >>> json_data_1 = '{"ver":"0x2","idx":"0","dir":"0x1","hwid":"0x2"}'
> > > >>> json_data_2 = '{"ver":2,"index":0,"dir":1,"hwid":2}'
> > > >>> parsed_json_1 = (json.loads(json_data_1))
> > > >>> parsed_json_2 = (json.loads(json_data_2))
> > > >>> print type(parsed_json_1["hwid"])
> > > >>> print type(parsed_json_2["hwid"])
> > > >>>
> > > >>> The output is:
> > > >>> <type 'unicode'>
> > > >>> <type 'int'>
> > > >>>
> > > >>> Also, '{"result": true}' is different from '{"result": "true"}' when
> > > >>> loading it in a 3rd-party lib.
> > > >>>
> > > >>> I think the JSON data coming from iproute2 is designed to be used by
> > > >>> a 3rd-party lib to parse, not just to show to users. To keep these
> > > >>> members' original type (numbers) is more appropriate, IMO.
> > > >>>
> > > >>
> > > >> Stephen: why do you think all of the numbers should be in hex?
> > > >>
> > > >> It seems like consistency with existing output should matter more.
> > > >> ip/link_gre.c for instance prints index as an int, version as an int,
> > > >> direction as a string and only hwid in hex.
> > > >>
> > > >> Xin: any reason you did not follow the output of the existingg netdev
> > > >> based solutions?
> > > > Hi David,
> > > >
> > > > Option is expressed as "version:index:dir:hwid", I made all fields
> > > > in this string of hex, just like "class:type:data" in:
> > > >
> > > > commit 0ed5269f9e41f495c8e9020c85f5e1644c1afc57
> > > > Author: Simon Horman <simon.horman@netronome.com>
> > > > Date:   Tue Jun 26 21:39:37 2018 -0700
> > > >
> > > >     net/sched: add tunnel option support to act_tunnel_key
> > > >
> > > > I'm not sure if it's good to mix multiple types in this string. wdyt?
> > > >
> > > > but for the JSON data, of course, these are all numbers(not string).
> > > >
> > >
> > > I don't understand why Stephen is pushing for hex; it does not make
> > > sense for version, index or direction. I don't have a clear
> > > understanding of hwid to know uint vs hex, so your current JSON prints
> > > seem fine.
> > >
> > > As for the stdout print and hex fields, staring at the tc and lwtunnel
> > > code, it seems like those 2 have a lot of parallels in expressing
> > > options for encoding vs lwtunnel and netdev based code. ie., I think
> > > this latest set is correct.
> > >
> > > Stephen?
> >
> > I just wanted:
> > 1. The parse and print functions should have the same formats.
> > I.e. if you take the output and do a little massaging of the ifindex
> > it should be accepted as an input set of parameters.
> >
> > 2. As much as possible, the JSON and non-JSON output should be similar.
> > If non-JSON prints in hex, then JSON should display hex and vice/versa.
> >
> > Ideally all inputs would be human format (not machine formats like hex).
> > But I guess the mistake was already made with some of the other tunnels.
> I guess we can't 'fix' these in other tunnels in tc.
>
> So I'm thinking we can either use the latest patchset,
> or keep the geneve opts format in lwtunnel consistent
> with the geneve opts in tc only and parse all with
> unint in the new erspan/vxlan tunnels opts.
Hi, Stephen and David A.

This patchset is in "deferred" status for a long time.
What should we do about this one?
should I improve something then repost or the lastest one will be fine.

Thanks.

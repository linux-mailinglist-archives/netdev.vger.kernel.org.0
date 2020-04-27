Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 372FA1BB1D2
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 01:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726253AbgD0XII (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 19:08:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726204AbgD0XII (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 19:08:08 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1D4BC0610D5
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 16:08:06 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id 18so8525380pfv.8
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 16:08:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QK396yuRzMC+xv2HHqM6tOPmCkw6z0hr1LJInMTYAXY=;
        b=BbuYLKpocRxNHCJgumnuN6msxlDgoBpZuUY3zGldcKzn7T3C3G5hPDnuoEHtavWWZ6
         0e7tVj66dhAK6BjZ8dv+bPwy17Swckoei5LME3Ov2MIh2kyO9UFAkgjmZhdOg8ywCM05
         WNdVGdKU7zwM8POcy0MsPqa1rITAIaBiWyUexi5cv1oq7CVHXhV8N/m6n6DIwTCHu3j+
         G3QGCsnruJV5BHnREMFWVLpPZmO+9SJV/Mspy1iSbg2PteM82v4TI/tK3+n4/TOFLVYA
         jiYAGnaXdYo1HWhWLqCsmNaZjMpAIkJ47+e8Jf4M6R6Uh0xlBd+MUvpSm1r3UJnFrk0y
         MNPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QK396yuRzMC+xv2HHqM6tOPmCkw6z0hr1LJInMTYAXY=;
        b=IEIvJYDpgjQFAmtgHWOLMR+Gg14VRkpEbnNgsMY0uCCm22Q6ar/vk5c0zwFCoOe1l/
         h0mHFydqTNHOZhvd2xwH3ggoa+hIgaJQ6c4nCZo5PfGs5Bx/eMLqwT5MUdEKJY7mEQ0l
         2Bc7izYLRO4+DKrQcID6EdV7fNuIgzbMjxHiYxskbr8uNFabRimGvMRbWcLQ88U2BT0t
         cQYVcK0U7wdIA1jVEam6VHF+w95E8lxaCgn5eq3m15CoYzHMjhngpz27+Vw4vIU1OD3W
         U++5r9I8paQE/+DvxAwmNUaNlSPfwr7EtkTQhNDXehYJI/m6spN5Ak+Luv7IE2Akz+WK
         W7pw==
X-Gm-Message-State: AGi0PuZBjCH/bvxWPwDU7gNijgb8si8chPHoLlLnfbG8apPI3G3ftsvn
        P+chcH4T/DFZ69i8pJsk+HX7vw==
X-Google-Smtp-Source: APiQypLnK0G70HqEybZKS8fMIFdEsGUlfdltbUsHWXmKzuOuPZmYlBqBMwBYh6JTw9+Jud1h+d9s3w==
X-Received: by 2002:a63:5f4d:: with SMTP id t74mr25402219pgb.385.1588028886282;
        Mon, 27 Apr 2020 16:08:06 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id 22sm13639305pfb.132.2020.04.27.16.08.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2020 16:08:05 -0700 (PDT)
Date:   Mon, 27 Apr 2020 16:07:57 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        Simon Horman <simon.horman@netronome.com>
Subject: Re: [PATCHv3 iproute2-next 3/7] iproute_lwtunnel: add options
 support for erspan metadata
Message-ID: <20200427160757.38ebc7a5@hermes.lan>
In-Reply-To: <70c448c7-cf2e-1f63-e4ea-03e73077c0d1@gmail.com>
References: <cover.1581676056.git.lucien.xin@gmail.com>
        <44db73e423003e95740f831e1d16a4043bb75034.1581676056.git.lucien.xin@gmail.com>
        <77f68795aeb3faeaf76078be9311fded7f716ea5.1581676056.git.lucien.xin@gmail.com>
        <290ab5d2dc06b183159d293ab216962a3cc0df6d.1581676056.git.lucien.xin@gmail.com>
        <20200214081324.48dc2090@hermes.lan>
        <CADvbK_dYwQ6LTuNPfGjdZPkFbrV2_vrX7OL7q3oR9830Mb8NcQ@mail.gmail.com>
        <20200423082351.5cd10f4d@hermes.lan>
        <20200423110307.6e35fc7d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <70c448c7-cf2e-1f63-e4ea-03e73077c0d1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 Apr 2020 06:38:03 -0600
David Ahern <dsahern@gmail.com> wrote:

> On 4/23/20 12:03 PM, Jakub Kicinski wrote:
> > On Thu, 23 Apr 2020 08:23:51 -0700 Stephen Hemminger wrote:  
> >>  3. If non json uses hex, then json should use hex
> >>     json is type less so { "ver":2 } and { "ver":"0x2" } are the same  
> > 
> > I may be missing something or misunderstanding you, but in my humble
> > experience that's emphatically not true:
> > 
> > $ echo '{ "a" : 2 }' | python -c 'import sys, json; print(json.load(sys.stdin)["a"] + 1)'
> > 3
> > $ echo '{ "a" : "2" }' | python -c 'import sys, json; print(json.load(sys.stdin)["a"] + 1)'
> > Traceback (most recent call last):
> >   File "<string>", line 1, in <module>
> > TypeError: can only concatenate str (not "int") to str
> >   
> 
> I don't know which site is the definitive source for json, but several
> do state json has several types - strings, number, true / false / null,
> object, array.

Probably I got confused because Python tries to be helpful...
JSON is ossified/standardized http://www.ecma-international.org/publications/files/ECMA-ST/ECMA-404.pdf

Best answer on the web was https://stackoverflow.com/questions/52671719/can-hex-format-be-used-with-json-files-if-so-how

   "JSON does not support hexadecimal numbers but they are supported in JSON5. json5.org"

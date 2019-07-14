Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEF2467DD0
	for <lists+netdev@lfdr.de>; Sun, 14 Jul 2019 08:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbfGNGdm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jul 2019 02:33:42 -0400
Received: from mail-pf1-f171.google.com ([209.85.210.171]:43947 "EHLO
        mail-pf1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbfGNGdm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Jul 2019 02:33:42 -0400
Received: by mail-pf1-f171.google.com with SMTP id i189so6019517pfg.10
        for <netdev@vger.kernel.org>; Sat, 13 Jul 2019 23:33:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L2VRdbV6fYK7O5D+dRluiYVKG0FHjp0oeOq/XHepens=;
        b=nYZoeMDYToCdyMXjgUJKOsJ+eGMWo7Uyp0i/tK8zu5PaoK0aUkgHw5iaN4fnBv1CGq
         pG06OdJXvunfWpmKqmxFOEiti+ngh6Gsro7NhvD8OsoXaZeenPfU/LIARwsldp6GlcDz
         3cnmQaTzf3UqFudqXZIo5jUHqljLJZ3JC34C92ezAKpryiK8G4GXvRh/Qa+Kt71qVZ7n
         oSl8ENdR681K0ECNL+iA4JeDfTeVQdEhIcfWNlRfLsmwOdJSHBg6yWwOdMg7/SDX0gOI
         vbWsfyboMlLMmFGYTl4Rgpo8RWwAKGsbKAZlIoECW6RRALjueZBDVOpttLJiQ4KAZZA8
         UJ4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L2VRdbV6fYK7O5D+dRluiYVKG0FHjp0oeOq/XHepens=;
        b=t2mG6ZEgKOxXgpq81p7t2XBD8+jQxPGqnzPxb0Oz1CJzpAwh0q421IwVxe/Y7OwK6z
         TYBlvGTsflowO7arUYGCF+THA2Erjk47ha/AfiRJ1Urq3Oac1tsFTSr3okMZHhtsOEVu
         xKNR6OsDUrPkb9wW40OwqO7jG81hOnFmhlw5omKDZnA/wyAxPP5G016eejNioc+FwAdf
         Douq2Rib4V+n1kt2KC+QtvNOUKU8DC8zWsF457vZW2uDrjglXRtK6/F5nmiT3U4QLSUC
         wBmGOG9H5DYD/aCxFl0eVbmI0IL4MfglOsulfcVLrwdMfZsoFrv2WFp9SLvfAm4ahQJ6
         Sbtw==
X-Gm-Message-State: APjAAAV/kMFXuz82Sm9r/1oTOXSxfjCFqF9wkL5DEj7PsPNvQKLw7tfG
        ko2Cw+AUbGyLdK6CfE+BTJC26jL00/Wn6oTCko4=
X-Google-Smtp-Source: APXvYqwdDzeefC/lQGxKHTs0EhChp0PetjMuW2/daJjnNsN6f+IZzsL6ONf8jctud1wcZBGdlxFW6Te0hAvLBG+QzXg=
X-Received: by 2002:a63:8a43:: with SMTP id y64mr20123535pgd.104.1563086020959;
 Sat, 13 Jul 2019 23:33:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190712201749.28421-2-xiyou.wangcong@gmail.com>
 <8355af23-100f-a3bb-0759-fca8b0aa583b@gmail.com> <CAM_iQpUd44ctMmtGrr4x_uA9UUxUdTzS-3tuySt2-jhM0y950A@mail.gmail.com>
In-Reply-To: <CAM_iQpUd44ctMmtGrr4x_uA9UUxUdTzS-3tuySt2-jhM0y950A@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sat, 13 Jul 2019 23:33:30 -0700
Message-ID: <CAM_iQpXbGuSTwSqfPvtK=Tt3araEXe=epkRrjWoNdtrw=mF2Ug@mail.gmail.com>
Subject: Re: [Patch net] fib: relax source validation check for loopback packets
To:     David Ahern <dsahern@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Julian Anastasov <ja@ssi.bg>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 13, 2019 at 11:30 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> It's complicated, Mesos network isolation uses this case:
> https://cgit.twitter.biz/mesos/tree/src/slave/containerizer/mesos/isolators/network/port_mapping.cpp

Oops, please use the open source link instead:
https://github.com/apache/mesos/blob/master/src/slave/containerizer/mesos/isolators/network/port_mapping.cpp

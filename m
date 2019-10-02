Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30B43C8DC0
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 18:07:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728255AbfJBQH3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 12:07:29 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:39841 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727978AbfJBQH3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 12:07:29 -0400
Received: by mail-ed1-f66.google.com with SMTP id a15so15758403edt.6
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 09:07:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UGa2u1OX6iCVBPb+wzk9Ci70IztieIqU/DbP4J4eknU=;
        b=TdjKXCoGbaZzBnM8p4/zT2qbSouVAWyn77oeJTxgzq3nohByBf1/Y+0T0L9BxfvrsW
         +XDWOC/gVU7fT6GgGqU1rtSLS2JtGvJ2TT5S39dMrtf1GBVH3gspTTZG0Cy4YAf7kwEQ
         +xCY/2tk0Bb7dTk9xmg7gdhhmGf/vGTHEUjxU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UGa2u1OX6iCVBPb+wzk9Ci70IztieIqU/DbP4J4eknU=;
        b=t73iYDjxlZHpivqDwI5Y/C3EydhLfSHVU2rbHFB9imT2z+EMrJ91jGyG2l3dxb5QC2
         BgVlzPxwYO69PTAdXFAh23q9Lw9Jeusq2xzH1iyh36wHDTBtkpYpRqGDtQklWSeN/9jC
         6Z0COB+eHwV7/thy75Q8br0/FdGumtk14SeojiuQhiaN7/QZnDJ7uk3EATZvMe27mxba
         WnZDCzTNkiaY9d4FaBqS8h9/L+F5dSB2SNPg9N4YBp5e2LZwCFnJrXZYvF0TBJawcokz
         mff6PxPr9/OJT+Aj57hEI5EyttwxiYpkognDVskuNWWJH7np7cQWi0g0tSjH0bzRUhNi
         NaEA==
X-Gm-Message-State: APjAAAU8uSIfTAWjSDppJyUo3mO64OuLyYRHPMPgM95DwYWK6Tx36ri2
        nfwzpG3eZLRQiNaEYYASOGt/hpFGdYRoYcB79TiZxQ==
X-Google-Smtp-Source: APXvYqwLOlrtRXmSu2iMl4gnxy6YHuM00GHsrWEKcGKT3jn35ahOFTs8Zx72kOwYDm+F25aXzX8Y7VAATX7ihF6DgSM=
X-Received: by 2002:a17:906:e10a:: with SMTP id gj10mr3705143ejb.134.1570032448006;
 Wed, 02 Oct 2019 09:07:28 -0700 (PDT)
MIME-Version: 1.0
References: <1569905543-33478-1-git-send-email-roopa@cumulusnetworks.com>
 <1569905543-33478-2-git-send-email-roopa@cumulusnetworks.com> <20191001075928.26f1dd43@hermes.lan>
In-Reply-To: <20191001075928.26f1dd43@hermes.lan>
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
Date:   Wed, 2 Oct 2019 09:07:17 -0700
Message-ID: <CAJieiUhs1Hr-LxEhO7Keary3MwPWtWTwwhZ=1+5kiawfxRU4Pw@mail.gmail.com>
Subject: Re: [PATCH iproute2 net-next v3 1/2] bridge: fdb get support
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     David Ahern <dsahern@gmail.com>, netdev <netdev@vger.kernel.org>,
        Ivan Vecera <ivecera@redhat.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 1, 2019 at 7:59 AM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Mon, 30 Sep 2019 21:52:22 -0700
> Roopa Prabhu <roopa@cumulusnetworks.com> wrote:
>
> > +
> > +     if (sscanf(addr, "%hhx:%hhx:%hhx:%hhx:%hhx:%hhx",
> > +                abuf, abuf+1, abuf+2,
> > +                abuf+3, abuf+4, abuf+5) != 6) {
> > +             fprintf(stderr, "Invalid mac address %s\n", addr);
> > +             return -1;
> > +     }
>
> You could use ether_aton here if that would help.
> Not required, but ether_ntoa already used in iplink_bridge.

ok ack, i will take a look. I think i picked this up from
bridge/fdb.c:fdb_modify

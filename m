Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAE1515FC8E
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 05:18:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727755AbgBOER5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 23:17:57 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42084 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727684AbgBOER5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 23:17:57 -0500
Received: by mail-wr1-f65.google.com with SMTP id k11so13219375wrd.9
        for <netdev@vger.kernel.org>; Fri, 14 Feb 2020 20:17:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XqiP7xtcPFo5Uwx6kW7+KewiywmHEOlHHjlQ5B8RWp8=;
        b=UeRE5Oe9K6NEjkwl+uno8y2FOdrmMO+G2afqghVmLieBCjHRZLn/Kc/AdDi5nTax23
         NGS9S3NyLeohwXu8Oh4qQhn/tclUyd599nunfF1/w6NxRK/zkEd4CVONrfyN0/GCe8vU
         4tRseicPs0SQkXIYOO7iS2K6G0t6ZbFsyoo+0Ij7qi/iwU+15++bvTCE54wPh+zHXj9G
         7FTySG5ssiKie8QGaO2SUvFwzMyaMC+hI/yvH1aOCyMy0B3y54HPUexMpJErsiOIkteW
         o0lDPLrAqNEhj2yfqnyx9TIIcNClIb9FHRG7CJkBJYTvFZjj+oJDFFCNqfV6pzlWCRjf
         fu5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XqiP7xtcPFo5Uwx6kW7+KewiywmHEOlHHjlQ5B8RWp8=;
        b=QdsHkDit9xFPoQ5+dTgNhsep/I6ypxySMhopSRMeYUVwwtRScyHdDa9W76NMYp/CGn
         iTasJfMjEjJFaLaBUWJxQTZyqruhiVjKAzP0iuDY9P2/m1eEr0iyHlEezpdsUYyTfo9+
         hGbMj4KVsKFEfRKDcFot5bF2vHDpJRTpXAYIpDE0y6SQHKbJUX41IcUY5wN+JB6iJEmx
         6U9EXxotxXHTB2TBpFID7wqIiiiktm+8RVZqtaqfc6CeDQTSFxooukIXrgAwMksAj7bm
         7+lgft0mA39W9LGY9yzogVRVbeL+m07OSTo15bzwCx53z8Wa66aA9gaofpQDpWEUR4LO
         GBJQ==
X-Gm-Message-State: APjAAAWQY84qUOGzLEo2XiWLN3Wj1mzlQaH3KNRa0G1KB8J6XCKC3yUq
        aluUSk1QfeZ+ttkkYbkhbgkAf0+jCrLu84MUgGk=
X-Google-Smtp-Source: APXvYqwW2PUzz8lp+Ewq2IUDYufuHbG4zHoBdQ30LQ2SLhGonpiM9QlnU2XZDh4HAvPs9v3oSDLTM5sUz8vsoVqunmk=
X-Received: by 2002:a5d:4c88:: with SMTP id z8mr7695308wrs.395.1581740274931;
 Fri, 14 Feb 2020 20:17:54 -0800 (PST)
MIME-Version: 1.0
References: <cover.1581676056.git.lucien.xin@gmail.com> <44db73e423003e95740f831e1d16a4043bb75034.1581676056.git.lucien.xin@gmail.com>
 <77f68795aeb3faeaf76078be9311fded7f716ea5.1581676056.git.lucien.xin@gmail.com>
 <290ab5d2dc06b183159d293ab216962a3cc0df6d.1581676056.git.lucien.xin@gmail.com>
 <20200214081324.48dc2090@hermes.lan> <CADvbK_dYwQ6LTuNPfGjdZPkFbrV2_vrX7OL7q3oR9830Mb8NcQ@mail.gmail.com>
 <20200214162104.04e0bb71@hermes.lan>
In-Reply-To: <20200214162104.04e0bb71@hermes.lan>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Sat, 15 Feb 2020 12:18:43 +0800
Message-ID: <CADvbK_eSiGXuZqHAdQTJugLa7mNUkuQTDmcuVYMHO=1VB+Cs8w@mail.gmail.com>
Subject: Re: [PATCHv3 iproute2-next 3/7] iproute_lwtunnel: add options support
 for erspan metadata
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     network dev <netdev@vger.kernel.org>,
        Simon Horman <simon.horman@netronome.com>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 15, 2020 at 8:21 AM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Sat, 15 Feb 2020 01:40:27 +0800
> Xin Long <lucien.xin@gmail.com> wrote:
>
> > This's not gonna work. as the output will be:
> > {"ver":"0x2","idx":"0","dir":"0x1","hwid":"0x2"}  (string)
> > instead of
> > {"ver":2,"index":0,"dir":1,"hwid":2} (number)
>
> JSON is typeless. Lots of values are already printed in hex
You may mean JSON data itself is typeless.
But JSON objects are typed when parsing JSON data, which includes
string, number, array, boolean. So it matters how to define the
members' 'type' in JSON data.

For example, in python's 'json' module:

#!/usr/bin/python2
import json
json_data_1 = '{"ver":"0x2","idx":"0","dir":"0x1","hwid":"0x2"}'
json_data_2 = '{"ver":2,"index":0,"dir":1,"hwid":2}'
parsed_json_1 = (json.loads(json_data_1))
parsed_json_2 = (json.loads(json_data_2))
print type(parsed_json_1["hwid"])
print type(parsed_json_2["hwid"])

The output is:
<type 'unicode'>
<type 'int'>

Also, '{"result": true}' is different from '{"result": "true"}' when
loading it in a 3rd-party lib.

I think the JSON data coming from iproute2 is designed to be used by
a 3rd-party lib to parse, not just to show to users. To keep these
members' original type (numbers) is more appropriate, IMO.

Thanks.

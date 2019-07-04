Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1BF55FE82
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 01:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727538AbfGDXAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 19:00:23 -0400
Received: from mail-ed1-f47.google.com ([209.85.208.47]:36127 "EHLO
        mail-ed1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726844AbfGDXAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 19:00:22 -0400
Received: by mail-ed1-f47.google.com with SMTP id k21so6627198edq.3
        for <netdev@vger.kernel.org>; Thu, 04 Jul 2019 16:00:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lam1UyyBJWZxb4UCbHSEipZAavcNF5Daa4xDJcB5HzA=;
        b=gpTkS+7YqPvH7WGDr+Ed+nMupveBlkd1+DsQZwoiXoRAFXqcFsyzqiccZHSmxFm/Vp
         PZiaMhJ2oRH81om128LZlTth5JCQ++dTEr1vy7BGSzMMXjJvx15sX5Qq8aMtVr9XMVzz
         LN3bCGYeUrPaBeqmrQMVDdRjOIWf1LFUf2nXYNRi68e/8P+wmKX1qycctxrMLPiyQHBq
         358S+4lViW5K/hHWdwyNQc5fSrXSqpzESFhlLD13CVlYQfgkh4j1Ann13cmXmixfgrSl
         U6xuZOlN5UkBxcN3XqGF8UPvEjCFZZEPgpkdXSE7R8han9lGUqWguXP/FJSfWNN72opI
         gElg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lam1UyyBJWZxb4UCbHSEipZAavcNF5Daa4xDJcB5HzA=;
        b=FJxcGN7ZBLFWjTtdC51YXkVCk8PPBZdPKdPpabVjJ0AIHSeEcP3UShCw8oWiEdVZw0
         2C06s+hW7Z3wj2WTEtavraIZ+Ew5+6iPC1Lyg5nIh106cN0gA3uaG37+XQ8iVQmaNN5Z
         qnqvEOIc83bsbIFWHxQy+SWUvp7xzkGXFjq5iiKW3FqzCQbDuAjUxmUIb6H0QpQepNbe
         bhwMjt7r2I/MTEM7l7u2NBDSQqg+GjVzTmKzy1aJAelB7siLPH1FFCA1KO3ScWknBYrS
         vq0PnAZTrJTO08je2Ac2FbLCzV3CH5krqs4YPfBx8+QA//wUTl5JbqyIx3hmZacZ2cWb
         jpUQ==
X-Gm-Message-State: APjAAAVKX/BOKw/7FT2uxuz2jmCSFoglejgkRKUhwz/S7KuwD2OFd1Ko
        Hw48VKtx4KBe9lsqu15mR4XYEoqcjJojjSWKefZw8ETm
X-Google-Smtp-Source: APXvYqzEQImXdZP/4P+3hxlE9nGPG9W6D1s9T1Iagfl7Q1qo0d/XT7groBZK+QdywaaSLPPnT83nDQGapYhrXXxXghM=
X-Received: by 2002:a50:eb8f:: with SMTP id y15mr1054409edr.31.1562281221211;
 Thu, 04 Jul 2019 16:00:21 -0700 (PDT)
MIME-Version: 1.0
References: <1562152028-2693-1-git-send-email-debrabander@gmail.com>
 <CAF=yD-+wHzfP6QWJzc=num_VaFvN3RYXV-c3+-VY8EjS87WEiA@mail.gmail.com> <d32bc4b8-b547-1d78-e245-2ec51df19c77@gmail.com>
In-Reply-To: <d32bc4b8-b547-1d78-e245-2ec51df19c77@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 4 Jul 2019 18:59:44 -0400
Message-ID: <CAF=yD-J-17g_riv367tCC7Go_iuqW4wqE=ye+=kKCxJ=oEXaiA@mail.gmail.com>
Subject: Re: bug: tpacket_snd can cause data corruption
To:     Frank de Brabander <debrabander@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Can you reproduce the issue when running the modified test in a
> > network namespace (./in_netns.sh ./txring_overwrite)?

> But even when running the test with ./in_netns.sh it shows
> "wrong pattern", this time without length mismatches:
>
> wrong pattern: 0x62 != 0x61
> wrong pattern: 0x62 != 0x61
> wrong pattern: 0x62 != 0x61
> wrong pattern: 0x62 != 0x61
> wrong pattern: 0x62 != 0x61
> wrong pattern: 0x62 != 0x61
> wrong pattern: 0x62 != 0x61
> wrong pattern: 0x62 != 0x61
> wrong pattern: 0x62 != 0x61
> wrong pattern: 0x62 != 0x61
>
> As already mentioned, it seems to trigger mainly (only ?) when
> an USB device is connected. The PC I'm testing this on has an
> USB hub with many ports and connected devices. When connecting
> this USB hub, the amount of "wrong pattern" errors that are
> shown seems to correlate to the amount of new devices
> that the kernel should detect. Connecting in a single USB device
> also triggers the error, but not on every attempt.
>
> Unfortunately have not found any other way to force the
> error to trigger. E.g. running stress-ng to generate CPU load or
> timer interrupts does not seem to have any impact.

Interesting, thanks for testing. No exact idea so far. The USB devices
are not necessarily network devices, I suppose? I don't immediately
have a setup to test the usb hotplug, so cannot yet reproduce the bug.

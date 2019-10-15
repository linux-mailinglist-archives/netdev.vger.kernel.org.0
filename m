Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40BA0D8135
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 22:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387869AbfJOUnR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 16:43:17 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:39427 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728710AbfJOUnR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 16:43:17 -0400
Received: by mail-pl1-f195.google.com with SMTP id s17so10143614plp.6
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 13:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=eFImrjlwDdis+S4o8zdHmAo7m61lA9Pv5l5C8m3KANo=;
        b=OKqm7J59nwIKVshenTUEOr2opHnEfHIAQMJqX8GpBiXLze1N3eR3dDbA5piG/3KkUn
         N051R8BJlarnW22RemwoK4YRFrZ9S/oCmBP69qDmhlXe6piEncMxYSUFG7fxVO3BR985
         MxqfK/uWrPKkbqZ5w080/ogRhpSRX7A7TASE0PclbC3ATrsnm/va9DGA9ZttsWctetzI
         vaigDm22uGGospdxjT3g+5IYWv52yt/DVEyjUItadRgdlt7Pa3Hd3noEytgWPCL3HstX
         BZO7XT0SXQ/BL92orL/yRbEvS0qyqJdUHKH8xdU9fUGPjrD3X+XBspljm0LQkMmrS0f1
         Ufiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=eFImrjlwDdis+S4o8zdHmAo7m61lA9Pv5l5C8m3KANo=;
        b=sY94v0w17WE/7A4qAn/gXD+0OI2S6DdGhDJtgNLEi6bAiQWcYgF1zgbPmOMdaF2yVx
         nZECog/R5zO6+lDYDUzxmswE4v1fwz11zfriUBGVR/V0KS7Rju34BR/mDGPLcYk2TCyB
         aymQUS3r14D4yGu6X/w4h/jc8vDvELti2JGAOWlcQFPjCwSHEDM+NQHCv+uTTZSRIAgi
         mA7PX5vmyj0PbJSd+/Mbg3WF8HvFGyuQsG+rg/7+HfoL3+Q/zNFM4ILoVS/Re1er1NsI
         MNkA/MkQrhL2a1GgXyWtm/Yq9+QuHphFfX8QG0mJKT35Sg/YoFfQR/CQFrWc0dlcchY6
         6CUg==
X-Gm-Message-State: APjAAAUbbi35EMjvMFo50qE3JN5u/1K7piI31n18bQm3Ig79AD+hUwqp
        GEhU1UMpaVhDDo76n6R1GqoGSg==
X-Google-Smtp-Source: APXvYqwv31P0O/zeULkdz7vnyZG3+/tPecj7FQSj+wdMlkN2FrFs3xCy4rQRJvPlh+rnYE7cTzgGDA==
X-Received: by 2002:a17:902:59d7:: with SMTP id d23mr36888998plj.153.1571172195475;
        Tue, 15 Oct 2019 13:43:15 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id y22sm182764pjn.12.2019.10.15.13.43.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Oct 2019 13:43:14 -0700 (PDT)
Date:   Tue, 15 Oct 2019 13:43:13 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Martin Lau <kafai@fb.com>
Cc:     Stanislav Fomichev <sdf@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
Subject: Re: [PATCH bpf-next 1/2] bpf: allow __sk_buff tstamp in
 BPF_PROG_TEST_RUN
Message-ID: <20191015204313.GA1897241@mini-arch>
References: <20191015183125.124413-1-sdf@google.com>
 <20191015203439.ilp7kp63mfruuzpc@kafai-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191015203439.ilp7kp63mfruuzpc@kafai-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/15, Martin Lau wrote:
> On Tue, Oct 15, 2019 at 11:31:24AM -0700, Stanislav Fomichev wrote:
> > It's useful for implementing EDT related tests (set tstamp, run the
> > test, see how the tstamp is changed or observe some other parameter).
> > 
> > Note that bpf_ktime_get_ns() helper is using monotonic clock, so for
> > the BPF programs that compare tstamp against it, tstamp should be
> > derived from clock_gettime(CLOCK_MONOTONIC, ...).
> Please provide a cover letter next time.  It makes ack-all possible.
SG, I'll try to add cover letter in the future if that helps.

If I remember correctly, acked-by to the cover letter was not
showing up in the patchwork and people usually do it for each patch
anyway. That's why I didn't bother to do it for this small change.

> Acked-by: Martin KaFai Lau <kafai@fb.com>

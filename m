Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 240AB1B5F0B
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 17:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729141AbgDWPYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 11:24:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729024AbgDWPYB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 11:24:01 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27996C08ED7D
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 08:24:00 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id ay1so2487453plb.0
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 08:24:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0uCeLEClZ2lNpZmAf1aBoYIHhwZ/qHrAxKVGfWGJTpU=;
        b=cjulySgo5MQcXrqWCZBz4UqtPdV78W3pRlvqvu/xrJzxCobxZ+aDnqCEgxQ+sZwWz3
         uXFhWnF+hAo+OJjBHMc+CN7Ju53KWN9218ftMggJr/0cQoeC629/GYd8zwo6Xdt81GyE
         pWyAGUr6APU/rOelDBv5AT1yOP2U+iDfOFJYiSrYlxO5UUZO6p+Q+qzbMOZZof06aGsG
         X3eqmSOj1Y8h5kHWgh+eiSoLu/UYf+Y3bARN9LCRQjl0sx+kABoQ/0wPmRc93+HnZRbP
         TcHsSlJ9pPtSnELoc8uT5Jo086MXYEyIwrB/nSBsNpWnAIxUDDsx+AO3I0LJq34wC7Uw
         BK/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0uCeLEClZ2lNpZmAf1aBoYIHhwZ/qHrAxKVGfWGJTpU=;
        b=DPZNksgCUyXeYfR0tOYvqt44GcBE1hMBMqk6X7PdA3yWMbgnegDQH8puhpeKNSDBHk
         EKFLB9yst3HIRQsdV9S2K3OnxJ3Uw5ZbEUOVlPuRGb8V0aUyn6MNLq8OiWZBQIUNtooP
         TawhpE1e6V78zlB8fLpA072rwSeXIRfWFflsGH2TvQsDCsU1OaSuTLbIWNAgNxCWKPDl
         9+mjF1/gZDsEF7SnA8uOTpYa7Gl/tf+cA1+Ila+GqXRig+44a92LORV6+jr7vwBJ7I96
         XxenmWEtPMrpOPqcr/L+E8KYEd+iRzpjMReFoH/1OW5FUpY1utd2O8pOFXOlNQGNG5Mi
         5dhg==
X-Gm-Message-State: AGi0PuZr510FIO6B2RpvsV+woQsUOX9afpf6rkhf38A7C4jSbF+kn3eT
        TSM8rv6evrx9t9VCB/sPy2RGXQ==
X-Google-Smtp-Source: APiQypK0tQw2xyAcFIEw7/FuYdxiKL+HK+Uv4G2fjonxZr0z3qJbIukCVUeFVa4HdC5fEbe5w++jYQ==
X-Received: by 2002:a17:902:7593:: with SMTP id j19mr4337437pll.62.1587655439582;
        Thu, 23 Apr 2020 08:23:59 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id c1sm2821202pfo.152.2020.04.23.08.23.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2020 08:23:59 -0700 (PDT)
Date:   Thu, 23 Apr 2020 08:23:51 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        Simon Horman <simon.horman@netronome.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCHv3 iproute2-next 3/7] iproute_lwtunnel: add options
 support for erspan metadata
Message-ID: <20200423082351.5cd10f4d@hermes.lan>
In-Reply-To: <CADvbK_dYwQ6LTuNPfGjdZPkFbrV2_vrX7OL7q3oR9830Mb8NcQ@mail.gmail.com>
References: <cover.1581676056.git.lucien.xin@gmail.com>
        <44db73e423003e95740f831e1d16a4043bb75034.1581676056.git.lucien.xin@gmail.com>
        <77f68795aeb3faeaf76078be9311fded7f716ea5.1581676056.git.lucien.xin@gmail.com>
        <290ab5d2dc06b183159d293ab216962a3cc0df6d.1581676056.git.lucien.xin@gmail.com>
        <20200214081324.48dc2090@hermes.lan>
        <CADvbK_dYwQ6LTuNPfGjdZPkFbrV2_vrX7OL7q3oR9830Mb8NcQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 15 Feb 2020 01:40:27 +0800
Xin Long <lucien.xin@gmail.com> wrote:

> On Sat, Feb 15, 2020 at 12:13 AM Stephen Hemminger
> <stephen@networkplumber.org> wrote:
> >
> > On Fri, 14 Feb 2020 18:30:47 +0800
> > Xin Long <lucien.xin@gmail.com> wrote:
> >  
> > > +
> > > +     open_json_array(PRINT_JSON, name);
> > > +     open_json_object(NULL);
> > > +     print_uint(PRINT_JSON, "ver", NULL, ver);
> > > +     print_uint(PRINT_JSON, "index", NULL, idx);
> > > +     print_uint(PRINT_JSON, "dir", NULL, dir);
> > > +     print_uint(PRINT_JSON, "hwid", NULL, hwid);
> > > +     close_json_object();
> > > +     close_json_array(PRINT_JSON, name);
> > > +
> > > +     print_nl();
> > > +     print_string(PRINT_FP, name, "\t%s ", name);
> > > +     sprintf(strbuf, "%02x:%08x:%02x:%02x", ver, idx, dir, hwid);
> > > +     print_string(PRINT_FP, NULL, "%s ", strbuf);
> > > +}  
> >
> > Instead of having two sets of prints, is it possible to do this
> >         print_nl();
> >         print_string(PRINT_FP, NULL, "\t", NULL);
> >
> >         open_json_array(PRINT_ANY, name);
> >         open_json_object(NULL);
> >         print_0xhex(PRINT_ANY, "ver", " %02x", ver);
> >         print_0xhex(PRINT_ANY, "idx", ":%08x", idx);
> >         print_0xhex(PRINT_ANY, "dir", ":%02x", dir);
> >         print_0xhex(PRINT_ANY, "hwid", ":%02x", hwid)
> >         close_json_object();
> >         close_json_array(PRINT_ANY, " ");  
> Hi Stephen,
> 
> This's not gonna work. as the output will be:
> {"ver":"0x2","idx":"0","dir":"0x1","hwid":"0x2"}  (string)
> instead of
> {"ver":2,"index":0,"dir":1,"hwid":2} (number)
> 
> >
> > Also, you seem to not hear the request to not use opaque hex values
> > in the iproute2 interface. The version, index, etc should be distinct
> > parameter values not a hex string.  
> The opts STRING, especially these like "XX:YY:ZZ" are represented
> as hex string on both adding and dumping. It is to keep consistent with
> geneve_opts in m_tunnel_key and f_flower,  see

There are several different requests.

 1. The format of the output must match the input.
 2. Printing values in hex would be nice if they are bit fields
 3. If non json uses hex, then json should use hex
    json is type less so { "ver":2 } and { "ver":"0x2" } are the same



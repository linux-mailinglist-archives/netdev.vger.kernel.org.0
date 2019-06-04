Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D93534EB3
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 19:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726223AbfFDRZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 13:25:26 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:43799 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725929AbfFDRZ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 13:25:26 -0400
Received: by mail-pf1-f193.google.com with SMTP id i189so1089060pfg.10
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 10:25:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=PEnpibrIKpCu2iEkrJv6LeRfFFOrIHGplvnyfi3Ur8o=;
        b=omE7b9WgUfKN33uTyi3k6gt3TSWJXT97cQ9LsipknGGR7S1pjOyfwVbcGSUXiXuWg8
         o1g495wOJhYjcZkzpA13RqqASCkrEqfeWGdh72f+VkOjvXzdYPIObMB+ueZCVnFoJDcZ
         tmCGlNvrAhNTdCCtX9D5zsmFEZ3Ba/Wx3pvTh3OTnxWhhe82Mw41AbhmTHdKC60EUqMu
         a330zfoZAoD0eiY0KYF2adGmqbar67NI1ljV7rZl65WZ+30Kpa+tqKnRFhigyrSnTum3
         PvFE6tDVcr3ntLNPeH0TTfD8X+neeP1STXSxf0H6x0mUnSXMwEeEPaQmfIGFcbAMVwHq
         NpbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=PEnpibrIKpCu2iEkrJv6LeRfFFOrIHGplvnyfi3Ur8o=;
        b=IIwSnXGXtNSp7qfILxqby2INemgQ6SZ6rohVnbprQPoDn2OZptrBay3NVFjYNcW+A8
         mk1CDUoc8UqaOynrc6KX6wRe/JV6kQqcwix/Hct6eWMStpbpfR+MN8KRAHAOf/5fSKKe
         InZ1Y3Bz0TlN2K62/YmdXC8+0rO847V0+xm+ptG9saOHD8dN3vKZvOCxlPzpzUVPsZh0
         4nU+FMnu1zm57FbyHZX39sLv/YwAy2VJxKiP89qNX20DyokcuY95orlm+FLVLENhKsNR
         XFzGR0H62sWE2V+77WG/vF1ItVGkb48CMT4Suow6UEcoq1H3IDD4DbrVu1ud1450wuD2
         bOnw==
X-Gm-Message-State: APjAAAUPLBy2exTFhhzVKGIjwc6l87/0MBCrXQNia016RpE3zddBTs15
        6NBLR85v715emaPbtFoufUA=
X-Google-Smtp-Source: APXvYqzQnOpU4QlZdprbUH/NaVGW8jyASJ8ivOE369sFcIDUsnx4jooux8oRyEOrzIdMy5gxYnER0Q==
X-Received: by 2002:a63:fb05:: with SMTP id o5mr37780696pgh.203.1559669125298;
        Tue, 04 Jun 2019 10:25:25 -0700 (PDT)
Received: from [172.20.52.202] ([2620:10d:c090:200::1:a068])
        by smtp.gmail.com with ESMTPSA id n1sm19431829pgv.15.2019.06.04.10.25.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 10:25:24 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Jesper Dangaard Brouer" <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, kernel-team@fb.com, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net
Subject: Re: [PATCH v4 bpf-next 1/2] bpf: Allow bpf_map_lookup_elem() on an
 xskmap
Date:   Tue, 04 Jun 2019 10:25:23 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <87399C88-4388-4857-AD77-E98527DEFDA4@gmail.com>
In-Reply-To: <20190604184306.362d9d8e@carbon>
References: <20190603163852.2535150-1-jonathan.lemon@gmail.com>
 <20190603163852.2535150-2-jonathan.lemon@gmail.com>
 <20190604184306.362d9d8e@carbon>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4 Jun 2019, at 9:43, Jesper Dangaard Brouer wrote:

> On Mon, 3 Jun 2019 09:38:51 -0700
> Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
>
>> Currently, the AF_XDP code uses a separate map in order to
>> determine if an xsk is bound to a queue.  Instead of doing this,
>> have bpf_map_lookup_elem() return the queue_id, as a way of
>> indicating that there is a valid entry at the map index.
>
> Just a reminder, that once we choose a return value, there the
> queue_id, then it basically becomes UAPI, and we cannot change it.

Yes - Alexei initially wanted to return the sk_cookie instead, but
that's 64 bits and opens up a whole other can of worms.


> Can we somehow use BTF to allow us to extend this later?
>
> I was also going to point out that, you cannot return a direct pointer
> to queue_id, as BPF-prog side can modify this... but Daniel already
> pointed this out.

So, I see three solutions here (for this and Toke's patchset also,
which is encountering the same problem).

1) add a scratch register (Toke's approach)
2) add a PTR_TO_<type>, which has the access checked.  This is the most
   flexible approach, but does seem a bit overkill at the moment.
3) add another helper function, say, bpf_map_elem_present() which just
   returns a boolean value indicating whether there is a valid map entry
   or not.

I was starting to do 2), but wanted to get some more feedback first.
-- 
Jonathan

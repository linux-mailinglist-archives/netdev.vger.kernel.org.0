Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F98C1130D0
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 18:30:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728169AbfLDRam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 12:30:42 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:35557 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726934AbfLDRam (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 12:30:42 -0500
Received: by mail-pl1-f193.google.com with SMTP id s10so19737plp.2
        for <netdev@vger.kernel.org>; Wed, 04 Dec 2019 09:30:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=IUMhmPzNJS6OUWDxn0WL/R+Ty9K7orUyiXqUYVAEZz0=;
        b=A+DNL8pGNpe6Q8EraPfmoTiK8b4OXPkesBs0KZ8LS3LmmLd8CvyU0ZOGOqth2QmQHd
         w5vItFR6Uvv6EHbRiSpbjlPxfqPMU7bW4dZo/NqGhKhaTScNUp79XsaFkGiCq6WsvLTZ
         JqZjDJyrq9YR4gn3r3IFzdUu1dsC6d3PdIT+lBNwo8fwCzddrsqlTlYslpvDrK9dUrlR
         WhsExDAVRqPFEQWOpgJZVkN2EnjWa+/dhlg4c1vlxJx2nsVhzRQwh1msljiGYFtE5b4V
         OdP6ZvoJkUqD9UdSVBdtoC1fcQ3KMGXlKfv02DWZrHFDEodyofdlCsLpMlZ+JHGYgKdN
         TxpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=IUMhmPzNJS6OUWDxn0WL/R+Ty9K7orUyiXqUYVAEZz0=;
        b=d4DFuVAlYoskzF8V4I2w63HQ/ppoMBDWYG4ZJIo9geHx2c8Os1KitaJLtUg6o/wRRp
         ReddxHwA9tm2pOU+t2nyBsZxz948vwAooyGlpz5Lgx7WOay0q1qhxhPDFmbdzXutDATN
         qfZmOcRZJTwA5z37GgEWsT0en0j//gl4l+XagXnsI2K/IKYc599q105hjyqOHky5BfLD
         3P3qx60MSFGwFkGRO1xiH/zvut2/5YHEoz8+QMel2ZLl4owdfmsiUu3Pjc7VUTqqdwft
         J2e08VY12/KEngeT98AsEeVymmYZxLw3VF/4LAoO6CANP49EIPdcU4hjtuUMIeNZrh6R
         2SRA==
X-Gm-Message-State: APjAAAX0NhupTyq29KGSLJyStRMfvNpgh4nLm5aL+qOxCqQClbLTsBjk
        Ys6FDLW7zFEWmXbgBuN+05E=
X-Google-Smtp-Source: APXvYqyBCZHQwvdgZxHD3Nvspj8hYFZrEUwtb8dab3PMcdl/J38jZv4l48U8IpT5SbwUAsGTMlZLNw==
X-Received: by 2002:a17:902:904c:: with SMTP id w12mr4624215plz.144.1575480641698;
        Wed, 04 Dec 2019 09:30:41 -0800 (PST)
Received: from [172.20.160.202] ([2620:10d:c090:180::5fe1])
        by smtp.gmail.com with ESMTPSA id p5sm8619748pga.69.2019.12.04.09.30.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Dec 2019 09:30:40 -0800 (PST)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Jesper Dangaard Brouer" <brouer@redhat.com>
Cc:     "Grygorii Strashko" <grygorii.strashko@ti.com>,
        netdev@vger.kernel.org, davem@davemloft.net, kernel-team@fb.com,
        "Ilias Apalodimas" <ilias.apalodimas@linaro.org>
Subject: Re: [net PATCH] xdp: obtain the mem_id mutex before trying to remove
 an entry.
Date:   Wed, 04 Dec 2019 09:30:18 -0800
X-Mailer: MailMate (1.13r5655)
Message-ID: <49A0ABFF-32CD-4F21-B091-0997DC805B7B@gmail.com>
In-Reply-To: <20191204123829.2af45813@carbon>
References: <20191203220114.1524992-1-jonathan.lemon@gmail.com>
 <20191204093240.581543f3@carbon>
 <64b28372-e203-92db-bc67-1c308334042f@ti.com>
 <20191204123829.2af45813@carbon>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4 Dec 2019, at 3:38, Jesper Dangaard Brouer wrote:

> On Wed, 4 Dec 2019 12:07:22 +0200
> Grygorii Strashko <grygorii.strashko@ti.com> wrote:
>
>> On 04/12/2019 10:32, Jesper Dangaard Brouer wrote:
>>> On Tue, 3 Dec 2019 14:01:14 -0800
>>> Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
>>>
>>>> A lockdep splat was observed when trying to remove an xdp memory
>>>> model from the table since the mutex was obtained when trying to
>>>> remove the entry, but not before the table walk started:
>>>>
>>>> Fix the splat by obtaining the lock before starting the table walk.
>>>>
>>>> Fixes: c3f812cea0d7 ("page_pool: do not release pool until inflight 
>>>> == 0.")
>>>> Reported-by: Grygorii Strashko <grygorii.strashko@ti.com>
>>>> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
>>>
>>> Have you tested if this patch fix the problem reported by Grygorii?

Yes, I reproduced the problem locally, and confirmed that the patch
resolves the issue.
--
Jonathan


>>>
>>> Link: 
>>> https://lore.kernel.org/netdev/c2de8927-7bca-612f-cdfd-e9112fee412a@ti.com
>>>
>>> Grygorii can you test this?
>>
>> Thanks.
>> I do not see this trace any more and networking is working after if 
>> down/up
>>
>> Tested-by: Grygorii Strashko <grygorii.strashko@ti.com>
>>
>
> Well if it fixes you issue, then I guess its okay.
>
> Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
>
> I just though it was related to the rcu_read_lock() around the
> page_pool_destroy() call. Guess, I was wrong.
>
> -- 
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer

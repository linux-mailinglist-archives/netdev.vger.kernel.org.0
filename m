Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D85F34E7D1
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 14:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231819AbhC3Msh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 08:48:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231919AbhC3Msa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 08:48:30 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5A84C061574;
        Tue, 30 Mar 2021 05:48:29 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id s17so19735738ljc.5;
        Tue, 30 Mar 2021 05:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=C/SEHAMdttQjA7hTIweXyWliIsCysW2EFbhutxpfmc8=;
        b=TWscK29HM7I/ddYkmtOgngIPWJTO1qpM0RVwB79bRr9h/HZtVMEDWtNB7g+t5nHJnw
         1eKHgE05+y4tqg4uEM/JQ6/Lf2LOR1F7EfqPbDjp2oOgAEDRdg0SBZ0AhYLWCv8DyUZK
         0vs1q9JCtsw2D+2yQkYayxcofjRTmOtraV86dndLMm86Hl5v45xIuuD6EKVEDcBwREPr
         UL8fwSaDMOlk4sytfubMIV5iStzNgJ3YA4MqDWZQau0mcgayOizgl6TYEWiFXl+FsY8x
         uUOjNo4TrrNov1jnPfF2RfVnwhOjTCs4vrYsXbKUSWWOv4hbmA2xKaxWZcbBL1GXMhCm
         gXfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=C/SEHAMdttQjA7hTIweXyWliIsCysW2EFbhutxpfmc8=;
        b=eLjYofkWaUcjp3KdLZemqWEf3A42aevrHYVWKoN6yvVjYhoi4bxbAYx3schhmfbKJy
         aFpkwoE8sHsbozGc9/7pmlo8PHkhL7mXobUXgrCVYb3LP14+hzen20ClADBMT5qrk2Hu
         zYf7Une1YBWLRNI9DRuNaer9Kp2RK2FnsC/a6PF8wny/39CIvVuMRuoSdT5Ti5gmm0qF
         9HieYaZE5Or8cg4E8rXtXg1RDbiTjc1KYX2BUZBfScW1BX/o/Ine93nvRBoKUXjmxEg/
         ta+IHhWYMDINbyJkoSoOVxkN2JiLrVYykXFcPd38IC93K3eDPJfujJiqDYZ3WfQ1qoKa
         qFHw==
X-Gm-Message-State: AOAM5317NSV+5LU6YCEPAbb+s3TYR9fOWL1fhu8NV0IJaB7lZLI+KZaV
        EBFfKrKnaRz0RarqqjuY7EA=
X-Google-Smtp-Source: ABdhPJyX9Npm/QMJKR4GWGM6FPXPKELHcT0PzZlOHr7Xeb4lumVtKBsLPYD35g2ae2eWqtXumI9xSw==
X-Received: by 2002:a2e:b5cd:: with SMTP id g13mr20825946ljn.372.1617108508345;
        Tue, 30 Mar 2021 05:48:28 -0700 (PDT)
Received: from [192.168.1.11] ([94.103.229.149])
        by smtp.gmail.com with ESMTPSA id x29sm2267266lfn.60.2021.03.30.05.48.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Mar 2021 05:48:27 -0700 (PDT)
Message-ID: <302c485c2209d54b88b54daa189589c76b4a66d0.camel@gmail.com>
Subject: Re: [PATCH] wireless/nl80211.c: fix uninitialized variable
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     Alaa Emad <alaaemadhossney.ae@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     johannes@sipsolutions.net, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        syzkaller <syzkaller@googlegroups.com>,
        syzbot+72b99dcf4607e8c770f3@syzkaller.appspotmail.com
Date:   Tue, 30 Mar 2021 15:48:24 +0300
In-Reply-To: <CAM1DhOjWgN_0GVBeX+pf+9mk_ysaN9pF4agAFUNEkzhxpFR4=w@mail.gmail.com>
References: <20210329163036.135761-1-alaaemadhossney.ae@gmail.com>
         <YGIaaezqxNmhVcmn@kroah.com>
         <CAM1DhOgA9DDaGSGFxKgXBONopoo4rLJZheK2jzW_BK-mJrNZKQ@mail.gmail.com>
         <YGIjOZauy9kPwINV@kroah.com>
         <CAM1DhOjWgN_0GVBeX+pf+9mk_ysaN9pF4agAFUNEkzhxpFR4=w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

On Tue, 2021-03-30 at 14:42 +0200, Alaa Emad wrote:
> 
> 
> On Mon, 29 Mar 2021 at 20:58, Greg KH <gregkh@linuxfoundation.org>
> wrote:
> > On Mon, Mar 29, 2021 at 08:41:38PM +0200, Alaa Emad wrote:
> > > On Mon, 29 Mar 2021 at 20:20, Greg KH <gregkh@linuxfoundation.org>
> > wrote:
> > > 
> > > > On Mon, Mar 29, 2021 at 06:30:36PM +0200, Alaa Emad wrote:
> > > > > Reported-by:
> > syzbot+72b99dcf4607e8c770f3@syzkaller.appspotmail.com
> > > > > Signed-off-by: Alaa Emad <alaaemadhossney.ae@gmail.com>
> > > > 
> > > > You need to provide some changelog text here, I know I can not
> > take
> > > > patches without that, maybe the wireless maintainer is more
> > flexible :)
> > > > 
> > >   you mean explain what i did , right?
> > 
> > Yes, explain why this change is needed.
> > 
> 
> 
>   
>   This change fix  KMSAN uninit-value in net/wireless/nl80211.c:225 ,
> That because of `fixedlen` variable uninitialized. 
>    So I initialized it by zero because the code assigned value to it
> after that and doesn't depend on any stored value in it . 

You should add this message to the patch, not just write it to
maintainer.

I think, this link might be
useful https://www.kernel.org/doc/html/v4.17/process/submitting-patches.html

> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> 
> 
> Thanks ,
> Alaa
> -- 
> You received this message because you are subscribed to the Google
> Groups "syzkaller" group.
> To unsubscribe from this group and stop receiving emails from it, send
> an email to syzkaller+unsubscribe@googlegroups.com.
> To view this discussion on the web visit
> https://groups.google.com/d/msgid/syzkaller/CAM1DhOjWgN_0GVBeX%2Bpf%2B9mk_ysaN9pF4agAFUNEkzhxpFR4%3Dw%40mail.gmail.com
> .

With regards,
Pavel Skripkin



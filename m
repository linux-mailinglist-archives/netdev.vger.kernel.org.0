Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB5C358FF5
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 00:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232834AbhDHWp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 18:45:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232265AbhDHWp5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 18:45:57 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD9DBC061760;
        Thu,  8 Apr 2021 15:45:45 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id z16so2435532pga.1;
        Thu, 08 Apr 2021 15:45:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1WCShYpdWslF/0WmdAE0NRX6VxETDo22lxze2KaNQNA=;
        b=tgrxYEBiaVzbYVcjwsyEejFoOyzyycGQpAawMGLzQiOVtvvuV/A7zvrDTx5nFcgE88
         8aBjGZvsv5QaCfKlBD0vd0T9sQMU/svv7nXWpr1UzCsJyS6eCWkO0+QVBU7uRhv6lo/w
         bQs+IJoxAin3x04F6zw+J7ar4LKuYHcUmNLstyas3gFObf3PawD+bTvbVd0KneDtabZ+
         /0xwRGqQaKgPmS/f6QpZwSLm5PCPuiptXq0CYkTwgwvYYAMf3vYHDf7hcAJJNUOwhoIN
         +rhgNHzMeWkRmLUsQX/yQQbMcBA9Cn7r/WVNy4CO5CFxxFXv+tBcxSZQfQWROt+Ek/WW
         YeHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1WCShYpdWslF/0WmdAE0NRX6VxETDo22lxze2KaNQNA=;
        b=SZeJ5fxGj5YcbAx5emtiDWKefbXq5twFL86xVwJ19y4Z2g4RuZCVFXVEVd4njzPnOe
         MYiBHVzSwdxVtPLa4vYWX6do1nSAcl7ewM1Kgz6/kTehOYmKns3tTngur27snysCKbeI
         rCSg4cprwhJLhBWydINAmNv/NRg+Puqi+GG2hjODBYZix6It+UYl5fGRD3Qv+DyFWyLG
         129vlRPw6AmPc8MhLc7C7zYyApzSNouSup6DViVP39sA8QSdRS9p9RHRBUKwxcnlIXXI
         2/ITVi97NH6es2gKmxE+gZj6cPzXewLUQXH0WjXPggWvnp+n55wHOeb3IqomL5sLH6yi
         GOiw==
X-Gm-Message-State: AOAM532vIzxe+/p2lSne0GAnMIce7T6SoSM1Lp89rQVlhOTxlphKSft3
        zF+eqyQMYSR+Ap1IQOu7x5I1SbjZQcTaiQ+8N7E=
X-Google-Smtp-Source: ABdhPJxtCYY/5ZK/dQOr3d3X95TEO/i9jC2iY0npXJuE3jw9Jx7CpRjf0OhVgCRW1r7yhEJPJY2vJ8BkONfoeUUcOGg=
X-Received: by 2002:a62:de83:0:b029:23e:6d5f:b166 with SMTP id
 h125-20020a62de830000b029023e6d5fb166mr9657165pfg.78.1617921945199; Thu, 08
 Apr 2021 15:45:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210401042635.19768-1-xiyou.wangcong@gmail.com>
 <B42B247A-4D0B-4DE9-B4D3-0C452472532D@fb.com> <CAM_iQpW-cuiYsPsu4mYZxZ1Oixffu2pV1TFg1c+eg9XT3wWwPQ@mail.gmail.com>
 <E0D5B076-A726-4845-8F12-640BAA853525@fb.com> <CAM_iQpWdO7efdcA2ovDsOF9XLhWJGgd6Be5qq0=xLphVBRE_Gw@mail.gmail.com>
 <93BBD473-7E1C-4A6E-8BB7-12E63D4799E8@fb.com> <CAM_iQpXEuxwQvT9FNqDa7y5kNpknA4xMNo_973ncy3iYaF-NTA@mail.gmail.com>
 <390A7E97-6A9A-48E4-A0B0-D1B9F5EB3308@fb.com> <CAM_iQpVZdju0KhTV1_jQYjad4p++hNAfikH5FsaOCZrcGFFDYA@mail.gmail.com>
 <93C90E13-4439-4467-811C-C6E410B1816D@fb.com> <CAM_iQpXrnXU85J=fa5+QjRqgo_evGfkfLU9_-aVdoyM_DJU2nA@mail.gmail.com>
 <DCAF6E05-7690-4B1D-B2AD-633B58E8985F@fb.com> <CAM_iQpW+=-RsxfYU_fWm+=9MSr6EzCvKwUayH3FyaPpopAtpWQ@mail.gmail.com>
 <45B3E744-000D-4958-89C0-A5E83959CD4A@fb.com> <CAM_iQpVwDvpMa2bVwx-2=ePGrkaeCG2HZh4szO9=vAP4ur4xzw@mail.gmail.com>
 <B014E4B4-D542-4005-97D5-5A3DDE446B95@fb.com>
In-Reply-To: <B014E4B4-D542-4005-97D5-5A3DDE446B95@fb.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 8 Apr 2021 15:45:34 -0700
Message-ID: <CAM_iQpU8gDm0Ry-CF8btPh6yk2QNYT57URpAxeZ7ZRQH-gaTpg@mail.gmail.com>
Subject: Re: [RFC Patch bpf-next] bpf: introduce bpf timer
To:     Song Liu <songliubraving@fb.com>
Cc:     "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>,
        "duanxiongchun@bytedance.com" <duanxiongchun@bytedance.com>,
        "wangdongdong.6@bytedance.com" <wangdongdong.6@bytedance.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 6, 2021 at 4:36 PM Song Liu <songliubraving@fb.com> wrote:
> I am not sure whether this makes sense. I feel there is still some
> misunderstanding. It will be helpful if you can share more information
> about the overall design.
>
> BTW: this could be a good topic for the BPF office hour. See more details
> here:
>
> https://docs.google.com/spreadsheets/d/1LfrDXZ9-fdhvPEp_LHkxAMYyxxpwBXjywWa0AejEveU/edit#gid=0
>

This is a good idea. I have requested for a slot next Thursday,
I am looking forward to discussing bpf timer at that time.

Thanks!

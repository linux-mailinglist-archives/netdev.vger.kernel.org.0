Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8515F4CE7F3
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 01:36:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232081AbiCFAgv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 19:36:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231961AbiCFAgu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 19:36:50 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 188286C951
        for <netdev@vger.kernel.org>; Sat,  5 Mar 2022 16:35:59 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id g39so20325857lfv.10
        for <netdev@vger.kernel.org>; Sat, 05 Mar 2022 16:35:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j4Ra526H+NZCm89/jh9lUgLut4XIdxUTokPmZF5ar7k=;
        b=LKN3ZJ730MVIffY4bOQ7BE3ZM0RBMdVBVqiL7X7zPIZOEPGMPBkY1/dP8Oa356hmCb
         vYa+dtjuGWYOZObNEfu643nTWYgv+dcgvQCmJpr7DyKeDPhmCX0GGI8JyjUqAGv1v83l
         y0YFIusUozLCQ0MJI+EBRmqjmWO9xvL+3ZvvM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j4Ra526H+NZCm89/jh9lUgLut4XIdxUTokPmZF5ar7k=;
        b=O81f764nqAUiynO5T0j+eAXhRtG6HbWC2LyvQVFtuDBQ6gR3C7657qYpnpJvv0qeTt
         TxMhcCekoa6c5qZbktkhnao/FJmzoCS9QNx2UE6GxOtMHykmmf70C5zEqy4NVXHp8esT
         lvgYEvKyR3t71P8asvw75SToTpU3vwJN40ZSxrQXGYQIrNPXwr+zovAeL2KCZCLvsQlK
         8zPg1XVJ9s2k+QD0J7pgccyUqWLfUKbpI71XEu8EAXCDC+IeQtVyYD+0F8ff4bNaD8SA
         qGn+GqYrU7Y9XxSL6kylH17kC/uLc3eBicKnz6WFoV9qQuwI/ERZF7WTe6zpFLF/lrCF
         iaxQ==
X-Gm-Message-State: AOAM530jGXDFRdysPLEnl+9HNdVATceOP2+LuPxwHz6JioGYrCNUmY2V
        uWewOZvmeykNdIhP3xk+8g62mHIS+Rk7Rjxy5R8=
X-Google-Smtp-Source: ABdhPJx19dG3jA0+ErFp0uGgRreqkT4HZASgFaQHkZgtJ+U9rfsZASFjst2CnAV5AaI7LcUHOgswvg==
X-Received: by 2002:a05:6512:20c2:b0:443:ee7c:2f42 with SMTP id u2-20020a05651220c200b00443ee7c2f42mr3654659lfr.612.1646526956814;
        Sat, 05 Mar 2022 16:35:56 -0800 (PST)
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com. [209.85.208.182])
        by smtp.gmail.com with ESMTPSA id v21-20020a2e2f15000000b002456e6cdab2sm2054642ljv.93.2022.03.05.16.35.52
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Mar 2022 16:35:54 -0800 (PST)
Received: by mail-lj1-f182.google.com with SMTP id s25so15733488lji.5
        for <netdev@vger.kernel.org>; Sat, 05 Mar 2022 16:35:52 -0800 (PST)
X-Received: by 2002:a2e:bc17:0:b0:246:32b7:464 with SMTP id
 b23-20020a2ebc17000000b0024632b70464mr3291904ljf.506.1646526952531; Sat, 05
 Mar 2022 16:35:52 -0800 (PST)
MIME-Version: 1.0
References: <CAHk-=whJX52b1jNsmzXeVr6Z898R=9rBcSYx2oLt69XKDbqhOg@mail.gmail.com>
 <20220304025109.15501-1-xiam0nd.tong@gmail.com> <CAHk-=wjesxw9U6JvTw34FREFAsayEE196Fi=VHtJXL8_9wgi=A@mail.gmail.com>
In-Reply-To: <CAHk-=wjesxw9U6JvTw34FREFAsayEE196Fi=VHtJXL8_9wgi=A@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 5 Mar 2022 16:35:36 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiacQM76xec=Hr7cLchVZ8Mo9VDHmXRJzJ_EX4sOsApEA@mail.gmail.com>
Message-ID: <CAHk-=wiacQM76xec=Hr7cLchVZ8Mo9VDHmXRJzJ_EX4sOsApEA@mail.gmail.com>
Subject: Re: [PATCH 2/6] list: add new MACROs to make iterator invisiable
 outside the loop
To:     Xiaomeng Tong <xiam0nd.tong@gmail.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakob Koschel <jakobkoschel@gmail.com>,
        Jann Horn <jannh@google.com>,
        Kees Cook <keescook@chromium.org>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>, Netdev <netdev@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000001ead5b05d981ee57"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000001ead5b05d981ee57
Content-Type: text/plain; charset="UTF-8"

On Sat, Mar 5, 2022 at 1:09 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Now, I'd love for the list head entry itself to "declare the type",
> and solve it that way. That would in many ways be the optimal
> situation, in that when a structure has that
>
>         struct list_head xyz;
>
> entry, it would be lovely to declare *there* what the list entry type
> is - and have 'list_for_each_entry()' just pick it up that way.
>
> It would be doable in theory - with some preprocessor trickery [...]

Ok, I decided to look at how that theory looks in real life.

The attached patch does actually work for me. I'm not saying this is
*beautiful*, but I made the changes to kernel/exit.c to show how this
can be used, and while the preprocessor tricks and the odd "unnamed
union with a special member to give the target type" is all kinds of
hacky, the actual use case code looks quite nice.

In particular, look at the "good case" list_for_each_entry() transformation:

   static int do_wait_thread(struct wait_opts *wo, struct task_struct *tsk)
   {
  -     struct task_struct *p;
  -
  -     list_for_each_entry(p, &tsk->children, sibling) {
  +     list_traverse(p, &tsk->children, sibling) {

IOW, it avoided the need to declare 'p' entirely, and it avoids the
need for a type, because the macro now *knows* the type of that
'tsk->children' list and picks it out automatically.

So 'list_traverse()' is basically a simplified version of
'list_for_each_entry()'.

That patch also has - as another example - the "use outside the loop"
case in mm_update_next_owner(). That is more of a "rewrite the loop
cleanly using list_traverse() thing, but it's also quite simple and
natural.

One nice part of this approach is that it allows for incremental changes.

In fact, the patch very much is meant to demonstrate exactly that:
yes, it converts the uses in kernel/exit.c, but it does *not* convert
the code in kernel/fork.c, which still does that old-style traversal:

                list_for_each_entry(child, &parent->children, sibling) {

and the kernel/fork.c code continues to work as well as it ever did.

So that new 'list_traverse()' function allows for people to say "ok, I
will now declare that list head with that list_traversal_head() macro,
and then I can convert 'list_for_each_entry()' users one by one to
this simpler syntax that also doesn't allow the list iterator to be
used outside the list.

What do people think? Is this clever and useful, or just too subtle
and odd to exist?

NOTE! I decided to add that "name of the target head in the target
type" to the list_traversal_head() macro, but it's not actually used
as is. It's more of a wishful "maybe we could add some sanity checking
of the target list entries later".

Comments?

                   Linus

--0000000000001ead5b05d981ee57
Content-Type: text/x-patch; charset="US-ASCII"; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_l0ejmgy80>
X-Attachment-Id: f_l0ejmgy80

IE1ha2VmaWxlICAgICAgICAgICAgICB8ICAyICstCiBpbmNsdWRlL2xpbnV4L2xpc3QuaCAgfCAx
NCArKysrKysrKysrKysrKwogaW5jbHVkZS9saW51eC9zY2hlZC5oIHwgIDQgKystLQoga2VybmVs
L2V4aXQuYyAgICAgICAgIHwgMjggKysrKysrKysrKysrKystLS0tLS0tLS0tLS0tLQogNCBmaWxl
cyBjaGFuZ2VkLCAzMSBpbnNlcnRpb25zKCspLCAxNyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQg
YS9NYWtlZmlsZSBiL01ha2VmaWxlCmluZGV4IGRhZWI1Yzg4YjUwYi4uY2M0YjBhMjY2YWYwIDEw
MDY0NAotLS0gYS9NYWtlZmlsZQorKysgYi9NYWtlZmlsZQpAQCAtNTE1LDcgKzUxNSw3IEBAIEtC
VUlMRF9DRkxBR1MgICA6PSAtV2FsbCAtV3VuZGVmIC1XZXJyb3I9c3RyaWN0LXByb3RvdHlwZXMg
LVduby10cmlncmFwaHMgXAogCQkgICAtZm5vLXN0cmljdC1hbGlhc2luZyAtZm5vLWNvbW1vbiAt
ZnNob3J0LXdjaGFyIC1mbm8tUElFIFwKIAkJICAgLVdlcnJvcj1pbXBsaWNpdC1mdW5jdGlvbi1k
ZWNsYXJhdGlvbiAtV2Vycm9yPWltcGxpY2l0LWludCBcCiAJCSAgIC1XZXJyb3I9cmV0dXJuLXR5
cGUgLVduby1mb3JtYXQtc2VjdXJpdHkgXAotCQkgICAtc3RkPWdudTg5CisJCSAgIC1zdGQ9Z251
MTEKIEtCVUlMRF9DUFBGTEFHUyA6PSAtRF9fS0VSTkVMX18KIEtCVUlMRF9BRkxBR1NfS0VSTkVM
IDo9CiBLQlVJTERfQ0ZMQUdTX0tFUk5FTCA6PQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9s
aXN0LmggYi9pbmNsdWRlL2xpbnV4L2xpc3QuaAppbmRleCBkZDZjMjA0MWQwOWMuLjFlOGIzZTQ5
NWI1MSAxMDA2NDQKLS0tIGEvaW5jbHVkZS9saW51eC9saXN0LmgKKysrIGIvaW5jbHVkZS9saW51
eC9saXN0LmgKQEAgLTI1LDYgKzI1LDkgQEAKICNkZWZpbmUgTElTVF9IRUFEKG5hbWUpIFwKIAlz
dHJ1Y3QgbGlzdF9oZWFkIG5hbWUgPSBMSVNUX0hFQURfSU5JVChuYW1lKQogCisjZGVmaW5lIGxp
c3RfdHJhdmVyc2FsX2hlYWQodHlwZSxuYW1lLHRhcmdldF9tZW1iZXIpIFwKKwl1bmlvbiB7IHN0
cnVjdCBsaXN0X2hlYWQgbmFtZTsgdHlwZSAqbmFtZSMjX3RyYXZlcnNhbF90eXBlOyB9CisKIC8q
KgogICogSU5JVF9MSVNUX0hFQUQgLSBJbml0aWFsaXplIGEgbGlzdF9oZWFkIHN0cnVjdHVyZQog
ICogQGxpc3Q6IGxpc3RfaGVhZCBzdHJ1Y3R1cmUgdG8gYmUgaW5pdGlhbGl6ZWQuCkBAIC02Mjgs
NiArNjMxLDE3IEBAIHN0YXRpYyBpbmxpbmUgdm9pZCBsaXN0X3NwbGljZV90YWlsX2luaXQoc3Ry
dWN0IGxpc3RfaGVhZCAqbGlzdCwKICNkZWZpbmUgbGlzdF9lbnRyeV9pc19oZWFkKHBvcywgaGVh
ZCwgbWVtYmVyKQkJCQlcCiAJKCZwb3MtPm1lbWJlciA9PSAoaGVhZCkpCiAKKy8qKgorICogbGlz
dF90cmF2ZXJzZSAtIGl0ZXJhdGUgb3ZlciBhIHR5cGVkIGxpc3QKKyAqIEBwb3M6CXRoZSBuYW1l
IHRvIHVzZSBmb3IgdGhlIGxvb3AgY3Vyc29yLgorICogQGhlYWQ6CXRoZSBoZWFkIGZvciB5b3Vy
IGxpc3QuCisgKiBAbWVtYmVyOgl0aGUgbmFtZSBvZiB0aGUgbGlzdF9oZWFkIHdpdGhpbiB0aGUg
dHlwZS4KKyAqLworI2RlZmluZSBsaXN0X3RyYXZlcnNlKHBvcywgaGVhZCwgbWVtYmVyKSBcCisJ
Zm9yICh0eXBlb2YoKmhlYWQjI190cmF2ZXJzYWxfdHlwZSkgcG9zID0gbGlzdF9maXJzdF9lbnRy
eShoZWFkLCB0eXBlb2YoKnBvcyksIG1lbWJlcik7IFwKKwkJIWxpc3RfZW50cnlfaXNfaGVhZChw
b3MsIGhlYWQsIG1lbWJlcik7CVwKKwkJcG9zID0gbGlzdF9uZXh0X2VudHJ5KHBvcywgbWVtYmVy
KSkKKwogLyoqCiAgKiBsaXN0X2Zvcl9lYWNoX2VudHJ5CS0JaXRlcmF0ZSBvdmVyIGxpc3Qgb2Yg
Z2l2ZW4gdHlwZQogICogQHBvczoJdGhlIHR5cGUgKiB0byB1c2UgYXMgYSBsb29wIGN1cnNvci4K
ZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvc2NoZWQuaCBiL2luY2x1ZGUvbGludXgvc2NoZWQu
aAppbmRleCA3NWJhOGFhNjAyNDguLjU1ZTYwNDA1ZGExYyAxMDA2NDQKLS0tIGEvaW5jbHVkZS9s
aW51eC9zY2hlZC5oCisrKyBiL2luY2x1ZGUvbGludXgvc2NoZWQuaApAQCAtOTY1LDcgKzk2NSw3
IEBAIHN0cnVjdCB0YXNrX3N0cnVjdCB7CiAJLyoKIAkgKiBDaGlsZHJlbi9zaWJsaW5nIGZvcm0g
dGhlIGxpc3Qgb2YgbmF0dXJhbCBjaGlsZHJlbjoKIAkgKi8KLQlzdHJ1Y3QgbGlzdF9oZWFkCQlj
aGlsZHJlbjsKKwlsaXN0X3RyYXZlcnNhbF9oZWFkKHN0cnVjdCB0YXNrX3N0cnVjdCwgY2hpbGRy
ZW4sIHNpYmxpbmcpOwogCXN0cnVjdCBsaXN0X2hlYWQJCXNpYmxpbmc7CiAJc3RydWN0IHRhc2tf
c3RydWN0CQkqZ3JvdXBfbGVhZGVyOwogCkBAIC05NzUsNyArOTc1LDcgQEAgc3RydWN0IHRhc2tf
c3RydWN0IHsKIAkgKiBUaGlzIGluY2x1ZGVzIGJvdGggbmF0dXJhbCBjaGlsZHJlbiBhbmQgUFRS
QUNFX0FUVEFDSCB0YXJnZXRzLgogCSAqICdwdHJhY2VfZW50cnknIGlzIHRoaXMgdGFzaydzIGxp
bmsgb24gdGhlIHAtPnBhcmVudC0+cHRyYWNlZCBsaXN0LgogCSAqLwotCXN0cnVjdCBsaXN0X2hl
YWQJCXB0cmFjZWQ7CisJbGlzdF90cmF2ZXJzYWxfaGVhZChzdHJ1Y3QgdGFza19zdHJ1Y3QsIHB0
cmFjZWQsIHB0cmFjZV9lbnRyeSk7CiAJc3RydWN0IGxpc3RfaGVhZAkJcHRyYWNlX2VudHJ5Owog
CiAJLyogUElEL1BJRCBoYXNoIHRhYmxlIGxpbmthZ2UuICovCmRpZmYgLS1naXQgYS9rZXJuZWwv
ZXhpdC5jIGIva2VybmVsL2V4aXQuYwppbmRleCBiMDBhMjViYjRhYjkuLmM4NWNiMWE2YmVjMiAx
MDA2NDQKLS0tIGEva2VybmVsL2V4aXQuYworKysgYi9rZXJuZWwvZXhpdC5jCkBAIC00MDksMTcg
KzQwOSwyMSBAQCB2b2lkIG1tX3VwZGF0ZV9uZXh0X293bmVyKHN0cnVjdCBtbV9zdHJ1Y3QgKm1t
KQogCS8qCiAJICogU2VhcmNoIGluIHRoZSBjaGlsZHJlbgogCSAqLwotCWxpc3RfZm9yX2VhY2hf
ZW50cnkoYywgJnAtPmNoaWxkcmVuLCBzaWJsaW5nKSB7Ci0JCWlmIChjLT5tbSA9PSBtbSkKLQkJ
CWdvdG8gYXNzaWduX25ld19vd25lcjsKKwlsaXN0X3RyYXZlcnNlKHBvcywgJnAtPmNoaWxkcmVu
LCBzaWJsaW5nKSB7CisJCWlmIChwb3MtPm1tICE9IG1tKQorCQkJY29udGludWU7CisJCWMgPSBw
b3M7CisJCWdvdG8gYXNzaWduX25ld19vd25lcjsKIAl9CiAKIAkvKgogCSAqIFNlYXJjaCBpbiB0
aGUgc2libGluZ3MKIAkgKi8KLQlsaXN0X2Zvcl9lYWNoX2VudHJ5KGMsICZwLT5yZWFsX3BhcmVu
dC0+Y2hpbGRyZW4sIHNpYmxpbmcpIHsKLQkJaWYgKGMtPm1tID09IG1tKQotCQkJZ290byBhc3Np
Z25fbmV3X293bmVyOworCWxpc3RfdHJhdmVyc2UocG9zLCAmcC0+cmVhbF9wYXJlbnQtPmNoaWxk
cmVuLCBzaWJsaW5nKSB7CisJCWlmIChwb3MtPm1tICE9IG1tKQorCQkJY29udGludWU7CisJCWMg
PSBwb3M7CisJCWdvdG8gYXNzaWduX25ld19vd25lcjsKIAl9CiAKIAkvKgpAQCAtNjI4LDcgKzYz
Miw3IEBAIHN0YXRpYyB2b2lkIHJlcGFyZW50X2xlYWRlcihzdHJ1Y3QgdGFza19zdHJ1Y3QgKmZh
dGhlciwgc3RydWN0IHRhc2tfc3RydWN0ICpwLAogc3RhdGljIHZvaWQgZm9yZ2V0X29yaWdpbmFs
X3BhcmVudChzdHJ1Y3QgdGFza19zdHJ1Y3QgKmZhdGhlciwKIAkJCQkJc3RydWN0IGxpc3RfaGVh
ZCAqZGVhZCkKIHsKLQlzdHJ1Y3QgdGFza19zdHJ1Y3QgKnAsICp0LCAqcmVhcGVyOworCXN0cnVj
dCB0YXNrX3N0cnVjdCAqdCwgKnJlYXBlcjsKIAogCWlmICh1bmxpa2VseSghbGlzdF9lbXB0eSgm
ZmF0aGVyLT5wdHJhY2VkKSkpCiAJCWV4aXRfcHRyYWNlKGZhdGhlciwgZGVhZCk7CkBAIC02Mzks
NyArNjQzLDcgQEAgc3RhdGljIHZvaWQgZm9yZ2V0X29yaWdpbmFsX3BhcmVudChzdHJ1Y3QgdGFz
a19zdHJ1Y3QgKmZhdGhlciwKIAkJcmV0dXJuOwogCiAJcmVhcGVyID0gZmluZF9uZXdfcmVhcGVy
KGZhdGhlciwgcmVhcGVyKTsKLQlsaXN0X2Zvcl9lYWNoX2VudHJ5KHAsICZmYXRoZXItPmNoaWxk
cmVuLCBzaWJsaW5nKSB7CisJbGlzdF90cmF2ZXJzZShwLCAmZmF0aGVyLT5jaGlsZHJlbiwgc2li
bGluZykgewogCQlmb3JfZWFjaF90aHJlYWQocCwgdCkgewogCQkJUkNVX0lOSVRfUE9JTlRFUih0
LT5yZWFsX3BhcmVudCwgcmVhcGVyKTsKIAkJCUJVR19PTigoIXQtPnB0cmFjZSkgIT0gKHJjdV9h
Y2Nlc3NfcG9pbnRlcih0LT5wYXJlbnQpID09IGZhdGhlcikpOwpAQCAtMTQwNSw5ICsxNDA5LDcg
QEAgc3RhdGljIGludCB3YWl0X2NvbnNpZGVyX3Rhc2soc3RydWN0IHdhaXRfb3B0cyAqd28sIGlu
dCBwdHJhY2UsCiAgKi8KIHN0YXRpYyBpbnQgZG9fd2FpdF90aHJlYWQoc3RydWN0IHdhaXRfb3B0
cyAqd28sIHN0cnVjdCB0YXNrX3N0cnVjdCAqdHNrKQogewotCXN0cnVjdCB0YXNrX3N0cnVjdCAq
cDsKLQotCWxpc3RfZm9yX2VhY2hfZW50cnkocCwgJnRzay0+Y2hpbGRyZW4sIHNpYmxpbmcpIHsK
KwlsaXN0X3RyYXZlcnNlKHAsICZ0c2stPmNoaWxkcmVuLCBzaWJsaW5nKSB7CiAJCWludCByZXQg
PSB3YWl0X2NvbnNpZGVyX3Rhc2sod28sIDAsIHApOwogCiAJCWlmIChyZXQpCkBAIC0xNDE5LDkg
KzE0MjEsNyBAQCBzdGF0aWMgaW50IGRvX3dhaXRfdGhyZWFkKHN0cnVjdCB3YWl0X29wdHMgKndv
LCBzdHJ1Y3QgdGFza19zdHJ1Y3QgKnRzaykKIAogc3RhdGljIGludCBwdHJhY2VfZG9fd2FpdChz
dHJ1Y3Qgd2FpdF9vcHRzICp3bywgc3RydWN0IHRhc2tfc3RydWN0ICp0c2spCiB7Ci0Jc3RydWN0
IHRhc2tfc3RydWN0ICpwOwotCi0JbGlzdF9mb3JfZWFjaF9lbnRyeShwLCAmdHNrLT5wdHJhY2Vk
LCBwdHJhY2VfZW50cnkpIHsKKwlsaXN0X3RyYXZlcnNlKHAsICZ0c2stPnB0cmFjZWQsIHB0cmFj
ZV9lbnRyeSkgewogCQlpbnQgcmV0ID0gd2FpdF9jb25zaWRlcl90YXNrKHdvLCAxLCBwKTsKIAog
CQlpZiAocmV0KQo=
--0000000000001ead5b05d981ee57--

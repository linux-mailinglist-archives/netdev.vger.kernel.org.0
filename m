Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 492FADE36E
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 07:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbfJUFCB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 01:02:01 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:46743 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727047AbfJUFCB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 01:02:01 -0400
Received: by mail-ot1-f68.google.com with SMTP id 89so9844720oth.13
        for <netdev@vger.kernel.org>; Sun, 20 Oct 2019 22:02:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x4FJL6M7GAZHGIKUZxVnMR8Hve0Sr14d7TsjvbEs81k=;
        b=gUwcE1tqh4xyHBdc9ruzVe3t8tk1BadSN05y/hTaHqtBPFrY1+0RI8Ew4RxsEF8x8W
         9Ic5dkKflCcokrfXn7F99z7MNqt19DqfedJf9lIkhDyshbO+UZIH2ddjQs/WAykiApV3
         cVZTJ7DpzOdVTPGybOJF/CW4CmAGTgaPGvmAh3VGDxwor4RMDZpxH3Ey4GdrkRBolBTe
         Ltmsl4lgUY1aEfCVkFTz4GXwdWFEJ5kVLsr5ysUDd9XUVr3uqzHdgj70WwWLzrgl5JaF
         txkOIY7xlvlocLaU1nPqnpvGA4xFslrZWVIqYu8DY1vTULeLkTUoRuJZmcvdR/EOR+yV
         TYGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x4FJL6M7GAZHGIKUZxVnMR8Hve0Sr14d7TsjvbEs81k=;
        b=cWt1ru2I2XT2cP/30Bpkko6iinYO15Ba8gtFbk8XJOYwrSYzBLHjgGF6wL48+SdYVN
         WNQ58QiRZT3fF+1ynVaHMylWE3fnQb92kxxWgXP6i+3h2HGJ9CPq1FS5ZM9ODrDoroGj
         QGzyAEt5KT/2tAQFtt2sRX+cUEL9s2SXVSKzeOpvNyvuYUEWbNBwilsr3KsEXz9+7YUY
         g1GjzdKS1W8r+iQjqLVCHLeXeuERE6tqDY0g1eVXrBQb4v39ioa3OJnM1r8BNWuLO+E7
         jBkTqlDF5sZNOLP76TsLlR4Xk9N20ReQnO6nLsSkb3UcXe6W3VfmhTkpIaIP9+IE8ntT
         6tmw==
X-Gm-Message-State: APjAAAVtdY61K9m+xhFP/PbBVfpD3MHlOIm6YjAYRFBXqcsZcsMSAhVI
        qUyo1wpD5y8XG65QtpS/yRHlb2OrR3J5k8ku5gtwX3II
X-Google-Smtp-Source: APXvYqwCzFlXHin3GMVIAKD/je0lH+IldIHRGp3dYnIKztDf/IlCuxoOgs1czrx+C4yyls50yCFgLORGr6R3qhmA5Lk=
X-Received: by 2002:a05:6830:13c7:: with SMTP id e7mr17306005otq.162.1571634120446;
 Sun, 20 Oct 2019 22:02:00 -0700 (PDT)
MIME-Version: 1.0
References: <1571135440-24313-1-git-send-email-xiangxia.m.yue@gmail.com>
 <1571135440-24313-9-git-send-email-xiangxia.m.yue@gmail.com>
 <CAOrHB_B5dLuvoTxGpmaMiX9deEk9KjQHacqNKEpzHA2m5YS7jw@mail.gmail.com>
 <CAMDZJNWD=a+EBneEU-qs3pzXSBoOdzidn5cgOKs-y8G0UWvbnA@mail.gmail.com> <CAOrHB_BqGdFmmzTEPxejt0QXmyC_QtAXG=S8kzKi=3w-PacwUw@mail.gmail.com>
In-Reply-To: <CAOrHB_BqGdFmmzTEPxejt0QXmyC_QtAXG=S8kzKi=3w-PacwUw@mail.gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Mon, 21 Oct 2019 13:01:24 +0800
Message-ID: <CAMDZJNXdu3R_GkHEBbwycEpe0wnwNmGzHx-8gUxtwiW1mEy7uw@mail.gmail.com>
Subject: Re: [PATCH net-next v4 08/10] net: openvswitch: fix possible memleak
 on destroy flow-table
To:     Pravin Shelar <pshelar@ovn.org>
Cc:     Greg Rose <gvrose8192@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        ovs dev <dev@openvswitch.org>
Content-Type: multipart/mixed; boundary="0000000000007782630595649544"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000007782630595649544
Content-Type: text/plain; charset="UTF-8"

On Sat, Oct 19, 2019 at 2:12 AM Pravin Shelar <pshelar@ovn.org> wrote:
>
> On Thu, Oct 17, 2019 at 8:16 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
> >
> > On Fri, Oct 18, 2019 at 6:38 AM Pravin Shelar <pshelar@ovn.org> wrote:
> > >
> > > On Wed, Oct 16, 2019 at 5:50 AM <xiangxia.m.yue@gmail.com> wrote:
> > > >
> > > > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > > >
> > > > When we destroy the flow tables which may contain the flow_mask,
> > > > so release the flow mask struct.
> > > >
> > > > Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > > > Tested-by: Greg Rose <gvrose8192@gmail.com>
> > > > ---
> > > >  net/openvswitch/flow_table.c | 14 +++++++++++++-
> > > >  1 file changed, 13 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
> > > > index 5df5182..d5d768e 100644
> > > > --- a/net/openvswitch/flow_table.c
> > > > +++ b/net/openvswitch/flow_table.c
> > > > @@ -295,6 +295,18 @@ static void table_instance_destroy(struct table_instance *ti,
> > > >         }
> > > >  }
> > > >
> > > > +static void tbl_mask_array_destroy(struct flow_table *tbl)
> > > > +{
> > > > +       struct mask_array *ma = ovsl_dereference(tbl->mask_array);
> > > > +       int i;
> > > > +
> > > > +       /* Free the flow-mask and kfree_rcu the NULL is allowed. */
> > > > +       for (i = 0; i < ma->max; i++)
> > > > +               kfree_rcu(rcu_dereference_raw(ma->masks[i]), rcu);
> > > > +
> > > > +       kfree_rcu(rcu_dereference_raw(tbl->mask_array), rcu);
> > > > +}
> > > > +
> > > >  /* No need for locking this function is called from RCU callback or
> > > >   * error path.
> > > >   */
> > > > @@ -304,7 +316,7 @@ void ovs_flow_tbl_destroy(struct flow_table *table)
> > > >         struct table_instance *ufid_ti = rcu_dereference_raw(table->ufid_ti);
> > > >
> > > >         free_percpu(table->mask_cache);
> > > > -       kfree_rcu(rcu_dereference_raw(table->mask_array), rcu);
> > > > +       tbl_mask_array_destroy(table);
> > > >         table_instance_destroy(ti, ufid_ti, false);
> > > >  }
> > >
> > > This should not be required. mask is linked to a flow and gets
> > > released when flow is removed.
> > > Does the memory leak occur when OVS module is abruptly unloaded and
> > > userspace does not cleanup flow table?
> > When we destroy the ovs datapath or net namespace is destroyed , the
> > mask memory will be happened. The call tree:
> > ovs_exit_net/ovs_dp_cmd_del
> > -->__dp_destroy
> > -->destroy_dp_rcu
> > -->ovs_flow_tbl_destroy
> > -->table_instance_destroy (which don't release the mask memory because
> > don't call the ovs_flow_tbl_remove /flow_mask_remove directly or
> > indirectly).
> >
> Thats what I suggested earlier, we need to call function similar to
> ovs_flow_tbl_remove(), we could refactor code to use the code.
> This is better since by introducing tbl_mask_array_destroy() is
> creating a dangling pointer to mask in sw-flow object. OVS is anyway
> iterating entire flow table to release sw-flow in
> table_instance_destroy(), it is natural to release mask at that point
> after releasing corresponding sw-flow.
I got it, thanks. I rewrite the codes, can you help me to review it.
If fine, I will sent it next version.
>
>
> > but one thing, when we flush the flow, we don't flush the mask flow.(
> > If necessary, one patch should be sent)
> >
> > > In that case better fix could be calling ovs_flow_tbl_remove()
> > > equivalent from table_instance_destroy when it is iterating flow
> > > table.
> > I think operation of  the flow mask and flow table should use
> > different API, for example:
> > for flow mask, we use the:
> > -tbl_mask_array_add_mask
> > -tbl_mask_array_del_mask
> > -tbl_mask_array_alloc
> > -tbl_mask_array_realloc
> > -tbl_mask_array_destroy(this patch introduce.)
> >
> > table instance:
> > -table_instance_alloc
> > -table_instance_destroy
> > ....

--0000000000007782630595649544
Content-Type: application/octet-stream; name="ovs-mem-leak.patch"
Content-Disposition: attachment; filename="ovs-mem-leak.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_k1zycm7l0>
X-Attachment-Id: f_k1zycm7l0

ZGlmZiAtLWdpdCBhL25ldC9vcGVudnN3aXRjaC9mbG93X3RhYmxlLmMgYi9uZXQvb3BlbnZzd2l0
Y2gvZmxvd190YWJsZS5jCmluZGV4IDVkZjUxODIuLjViMjA3OTMgMTAwNjQ0Ci0tLSBhL25ldC9v
cGVudnN3aXRjaC9mbG93X3RhYmxlLmMKKysrIGIvbmV0L29wZW52c3dpdGNoL2Zsb3dfdGFibGUu
YwpAQCAtMjU3LDEwICsyNTcsNzUgQEAgc3RhdGljIHZvaWQgZmxvd190YmxfZGVzdHJveV9yY3Vf
Y2Ioc3RydWN0IHJjdV9oZWFkICpyY3UpCiAJX190YWJsZV9pbnN0YW5jZV9kZXN0cm95KHRpKTsK
IH0KIAotc3RhdGljIHZvaWQgdGFibGVfaW5zdGFuY2VfZGVzdHJveShzdHJ1Y3QgdGFibGVfaW5z
dGFuY2UgKnRpLAotCQkJCSAgIHN0cnVjdCB0YWJsZV9pbnN0YW5jZSAqdWZpZF90aSwKK3N0YXRp
YyB2b2lkIHRibF9tYXNrX2FycmF5X2RlbF9tYXNrKHN0cnVjdCBmbG93X3RhYmxlICp0YmwsCisJ
CQkJICAgIHN0cnVjdCBzd19mbG93X21hc2sgKm1hc2spCit7CisJc3RydWN0IG1hc2tfYXJyYXkg
Km1hID0gb3ZzbF9kZXJlZmVyZW5jZSh0YmwtPm1hc2tfYXJyYXkpOworCWludCBpLCBtYV9jb3Vu
dCA9IFJFQURfT05DRShtYS0+Y291bnQpOworCisJLyogUmVtb3ZlIHRoZSBkZWxldGVkIG1hc2sg
cG9pbnRlcnMgZnJvbSB0aGUgYXJyYXkgKi8KKwlmb3IgKGkgPSAwOyBpIDwgbWFfY291bnQ7IGkr
KykgeworCQlpZiAobWFzayA9PSBvdnNsX2RlcmVmZXJlbmNlKG1hLT5tYXNrc1tpXSkpCisJCQln
b3RvIGZvdW5kOworCX0KKworCUJVRygpOworCXJldHVybjsKKworZm91bmQ6CisJV1JJVEVfT05D
RShtYS0+Y291bnQsIG1hX2NvdW50IC0xKTsKKworCXJjdV9hc3NpZ25fcG9pbnRlcihtYS0+bWFz
a3NbaV0sIG1hLT5tYXNrc1ttYV9jb3VudCAtMV0pOworCVJDVV9JTklUX1BPSU5URVIobWEtPm1h
c2tzW21hX2NvdW50IC0xXSwgTlVMTCk7CisKKwlrZnJlZV9yY3UobWFzaywgcmN1KTsKKworCS8q
IFNocmluayB0aGUgbWFzayBhcnJheSBpZiBuZWNlc3NhcnkuICovCisJaWYgKG1hLT5tYXggPj0g
KE1BU0tfQVJSQVlfU0laRV9NSU4gKiAyKSAmJgorCSAgICBtYV9jb3VudCA8PSAobWEtPm1heCAv
IDMpKQorCQl0YmxfbWFza19hcnJheV9yZWFsbG9jKHRibCwgbWEtPm1heCAvIDIpOworfQorCisv
KiBSZW1vdmUgJ21hc2snIGZyb20gdGhlIG1hc2sgbGlzdCwgaWYgaXQgaXMgbm90IG5lZWRlZCBh
bnkgbW9yZS4gKi8KK3N0YXRpYyB2b2lkIGZsb3dfbWFza19yZW1vdmUoc3RydWN0IGZsb3dfdGFi
bGUgKnRibCwgc3RydWN0IHN3X2Zsb3dfbWFzayAqbWFzaykKK3sKKwlpZiAobWFzaykgeworCQkv
KiBvdnMtbG9jayBpcyByZXF1aXJlZCB0byBwcm90ZWN0IG1hc2stcmVmY291bnQgYW5kCisJCSAq
IG1hc2sgbGlzdC4KKwkJICovCisJCUFTU0VSVF9PVlNMKCk7CisJCUJVR19PTighbWFzay0+cmVm
X2NvdW50KTsKKwkJbWFzay0+cmVmX2NvdW50LS07CisKKwkJaWYgKCFtYXNrLT5yZWZfY291bnQp
CisJCQl0YmxfbWFza19hcnJheV9kZWxfbWFzayh0YmwsIG1hc2spOworCX0KK30KKworc3RhdGlj
IHZvaWQgdGFibGVfaW5zdGFuY2VfcmVtb3ZlKHN0cnVjdCBmbG93X3RhYmxlICp0YWJsZSwgc3Ry
dWN0IHN3X2Zsb3cgKmZsb3cpCit7CisJc3RydWN0IHRhYmxlX2luc3RhbmNlICp0aSA9IG92c2xf
ZGVyZWZlcmVuY2UodGFibGUtPnRpKTsKKwlzdHJ1Y3QgdGFibGVfaW5zdGFuY2UgKnVmaWRfdGkg
PSBvdnNsX2RlcmVmZXJlbmNlKHRhYmxlLT51ZmlkX3RpKTsKKworCUJVR19PTih0YWJsZS0+Y291
bnQgPT0gMCk7CisJaGxpc3RfZGVsX3JjdSgmZmxvdy0+Zmxvd190YWJsZS5ub2RlW3RpLT5ub2Rl
X3Zlcl0pOworCXRhYmxlLT5jb3VudC0tOworCWlmIChvdnNfaWRlbnRpZmllcl9pc191ZmlkKCZm
bG93LT5pZCkpIHsKKwkJaGxpc3RfZGVsX3JjdSgmZmxvdy0+dWZpZF90YWJsZS5ub2RlW3VmaWRf
dGktPm5vZGVfdmVyXSk7CisJCXRhYmxlLT51ZmlkX2NvdW50LS07CisJfQorCisJLyogUkNVIGRl
bGV0ZSB0aGUgbWFzay4gJ2Zsb3ctPm1hc2snIGlzIG5vdCBOVUxMZWQsIGFzIGl0IHNob3VsZCBi
ZQorCSAqIGFjY2Vzc2libGUgYXMgbG9uZyBhcyB0aGUgUkNVIHJlYWQgbG9jayBpcyBoZWxkLgor
CSAqLworCWZsb3dfbWFza19yZW1vdmUodGFibGUsIGZsb3ctPm1hc2spOworfQorCitzdGF0aWMg
dm9pZCB0YWJsZV9pbnN0YW5jZV9kZXN0cm95KHN0cnVjdCBmbG93X3RhYmxlICp0YWJsZSwKIAkJ
CQkgICBib29sIGRlZmVycmVkKQogeworCXN0cnVjdCB0YWJsZV9pbnN0YW5jZSAqdGkgPSBvdnNs
X2RlcmVmZXJlbmNlKHRhYmxlLT50aSk7CisJc3RydWN0IHRhYmxlX2luc3RhbmNlICp1ZmlkX3Rp
ID0gb3ZzbF9kZXJlZmVyZW5jZSh0YWJsZS0+dWZpZF90aSk7CiAJaW50IGk7CiAKIAlpZiAoIXRp
KQpAQCAtMjc0LDEzICszMzksOSBAQCBzdGF0aWMgdm9pZCB0YWJsZV9pbnN0YW5jZV9kZXN0cm95
KHN0cnVjdCB0YWJsZV9pbnN0YW5jZSAqdGksCiAJCXN0cnVjdCBzd19mbG93ICpmbG93OwogCQlz
dHJ1Y3QgaGxpc3RfaGVhZCAqaGVhZCA9ICZ0aS0+YnVja2V0c1tpXTsKIAkJc3RydWN0IGhsaXN0
X25vZGUgKm47Ci0JCWludCB2ZXIgPSB0aS0+bm9kZV92ZXI7Ci0JCWludCB1ZmlkX3ZlciA9IHVm
aWRfdGktPm5vZGVfdmVyOwogCi0JCWhsaXN0X2Zvcl9lYWNoX2VudHJ5X3NhZmUoZmxvdywgbiwg
aGVhZCwgZmxvd190YWJsZS5ub2RlW3Zlcl0pIHsKLQkJCWhsaXN0X2RlbF9yY3UoJmZsb3ctPmZs
b3dfdGFibGUubm9kZVt2ZXJdKTsKLQkJCWlmIChvdnNfaWRlbnRpZmllcl9pc191ZmlkKCZmbG93
LT5pZCkpCi0JCQkJaGxpc3RfZGVsX3JjdSgmZmxvdy0+dWZpZF90YWJsZS5ub2RlW3VmaWRfdmVy
XSk7CisJCWhsaXN0X2Zvcl9lYWNoX2VudHJ5X3NhZmUoZmxvdywgbiwgaGVhZCwgZmxvd190YWJs
ZS5ub2RlW3RpLT5ub2RlX3Zlcl0pIHsKKwkJCXRhYmxlX2luc3RhbmNlX3JlbW92ZSh0YWJsZSwg
Zmxvdyk7CiAJCQlvdnNfZmxvd19mcmVlKGZsb3csIGRlZmVycmVkKTsKIAkJfQogCX0KQEAgLTMw
MCwxMiArMzYxLDkgQEAgc3RhdGljIHZvaWQgdGFibGVfaW5zdGFuY2VfZGVzdHJveShzdHJ1Y3Qg
dGFibGVfaW5zdGFuY2UgKnRpLAogICovCiB2b2lkIG92c19mbG93X3RibF9kZXN0cm95KHN0cnVj
dCBmbG93X3RhYmxlICp0YWJsZSkKIHsKLQlzdHJ1Y3QgdGFibGVfaW5zdGFuY2UgKnRpID0gcmN1
X2RlcmVmZXJlbmNlX3Jhdyh0YWJsZS0+dGkpOwotCXN0cnVjdCB0YWJsZV9pbnN0YW5jZSAqdWZp
ZF90aSA9IHJjdV9kZXJlZmVyZW5jZV9yYXcodGFibGUtPnVmaWRfdGkpOwotCiAJZnJlZV9wZXJj
cHUodGFibGUtPm1hc2tfY2FjaGUpOwogCWtmcmVlX3JjdShyY3VfZGVyZWZlcmVuY2VfcmF3KHRh
YmxlLT5tYXNrX2FycmF5KSwgcmN1KTsKLQl0YWJsZV9pbnN0YW5jZV9kZXN0cm95KHRpLCB1Zmlk
X3RpLCBmYWxzZSk7CisJdGFibGVfaW5zdGFuY2VfZGVzdHJveSh0YWJsZSwgZmFsc2UpOwogfQog
CiBzdHJ1Y3Qgc3dfZmxvdyAqb3ZzX2Zsb3dfdGJsX2R1bXBfbmV4dChzdHJ1Y3QgdGFibGVfaW5z
dGFuY2UgKnRpLApAQCAtNDAwLDEwICs0NTgsOSBAQCBzdGF0aWMgc3RydWN0IHRhYmxlX2luc3Rh
bmNlICp0YWJsZV9pbnN0YW5jZV9yZWhhc2goc3RydWN0IHRhYmxlX2luc3RhbmNlICp0aSwKIAly
ZXR1cm4gbmV3X3RpOwogfQogCi1pbnQgb3ZzX2Zsb3dfdGJsX2ZsdXNoKHN0cnVjdCBmbG93X3Rh
YmxlICpmbG93X3RhYmxlKQoraW50IG92c19mbG93X3RibF9mbHVzaChzdHJ1Y3QgZmxvd190YWJs
ZSAqdGFibGUpCiB7Ci0Jc3RydWN0IHRhYmxlX2luc3RhbmNlICpvbGRfdGksICpuZXdfdGk7Ci0J
c3RydWN0IHRhYmxlX2luc3RhbmNlICpvbGRfdWZpZF90aSwgKm5ld191ZmlkX3RpOworCXN0cnVj
dCB0YWJsZV9pbnN0YW5jZSAqbmV3X3RpLCAqbmV3X3VmaWRfdGk7CiAKIAluZXdfdGkgPSB0YWJs
ZV9pbnN0YW5jZV9hbGxvYyhUQkxfTUlOX0JVQ0tFVFMpOwogCWlmICghbmV3X3RpKQpAQCAtNDEy
LDE2ICs0NjksMTIgQEAgaW50IG92c19mbG93X3RibF9mbHVzaChzdHJ1Y3QgZmxvd190YWJsZSAq
Zmxvd190YWJsZSkKIAlpZiAoIW5ld191ZmlkX3RpKQogCQlnb3RvIGVycl9mcmVlX3RpOwogCi0J
b2xkX3RpID0gb3ZzbF9kZXJlZmVyZW5jZShmbG93X3RhYmxlLT50aSk7Ci0Jb2xkX3VmaWRfdGkg
PSBvdnNsX2RlcmVmZXJlbmNlKGZsb3dfdGFibGUtPnVmaWRfdGkpOworCXRhYmxlX2luc3RhbmNl
X2Rlc3Ryb3kodGFibGUsIHRydWUpOwogCi0JcmN1X2Fzc2lnbl9wb2ludGVyKGZsb3dfdGFibGUt
PnRpLCBuZXdfdGkpOwotCXJjdV9hc3NpZ25fcG9pbnRlcihmbG93X3RhYmxlLT51ZmlkX3RpLCBu
ZXdfdWZpZF90aSk7Ci0JZmxvd190YWJsZS0+bGFzdF9yZWhhc2ggPSBqaWZmaWVzOwotCWZsb3df
dGFibGUtPmNvdW50ID0gMDsKLQlmbG93X3RhYmxlLT51ZmlkX2NvdW50ID0gMDsKKwlyY3VfYXNz
aWduX3BvaW50ZXIodGFibGUtPnRpLCBuZXdfdGkpOworCXJjdV9hc3NpZ25fcG9pbnRlcih0YWJs
ZS0+dWZpZF90aSwgbmV3X3VmaWRfdGkpOworCXRhYmxlLT5sYXN0X3JlaGFzaCA9IGppZmZpZXM7
CiAKLQl0YWJsZV9pbnN0YW5jZV9kZXN0cm95KG9sZF90aSwgb2xkX3VmaWRfdGksIHRydWUpOwog
CXJldHVybiAwOwogCiBlcnJfZnJlZV90aToKQEAgLTcwMCw2OSArNzUzLDEwIEBAIHN0YXRpYyBz
dHJ1Y3QgdGFibGVfaW5zdGFuY2UgKnRhYmxlX2luc3RhbmNlX2V4cGFuZChzdHJ1Y3QgdGFibGVf
aW5zdGFuY2UgKnRpLAogCXJldHVybiB0YWJsZV9pbnN0YW5jZV9yZWhhc2godGksIHRpLT5uX2J1
Y2tldHMgKiAyLCB1ZmlkKTsKIH0KIAotc3RhdGljIHZvaWQgdGJsX21hc2tfYXJyYXlfZGVsX21h
c2soc3RydWN0IGZsb3dfdGFibGUgKnRibCwKLQkJCQkgICAgc3RydWN0IHN3X2Zsb3dfbWFzayAq
bWFzaykKLXsKLQlzdHJ1Y3QgbWFza19hcnJheSAqbWEgPSBvdnNsX2RlcmVmZXJlbmNlKHRibC0+
bWFza19hcnJheSk7Ci0JaW50IGksIG1hX2NvdW50ID0gUkVBRF9PTkNFKG1hLT5jb3VudCk7Ci0K
LQkvKiBSZW1vdmUgdGhlIGRlbGV0ZWQgbWFzayBwb2ludGVycyBmcm9tIHRoZSBhcnJheSAqLwot
CWZvciAoaSA9IDA7IGkgPCBtYV9jb3VudDsgaSsrKSB7Ci0JCWlmIChtYXNrID09IG92c2xfZGVy
ZWZlcmVuY2UobWEtPm1hc2tzW2ldKSkKLQkJCWdvdG8gZm91bmQ7Ci0JfQotCi0JQlVHKCk7Ci0J
cmV0dXJuOwotCi1mb3VuZDoKLQlXUklURV9PTkNFKG1hLT5jb3VudCwgbWFfY291bnQgLTEpOwot
Ci0JcmN1X2Fzc2lnbl9wb2ludGVyKG1hLT5tYXNrc1tpXSwgbWEtPm1hc2tzW21hX2NvdW50IC0x
XSk7Ci0JUkNVX0lOSVRfUE9JTlRFUihtYS0+bWFza3NbbWFfY291bnQgLTFdLCBOVUxMKTsKLQot
CWtmcmVlX3JjdShtYXNrLCByY3UpOwotCi0JLyogU2hyaW5rIHRoZSBtYXNrIGFycmF5IGlmIG5l
Y2Vzc2FyeS4gKi8KLQlpZiAobWEtPm1heCA+PSAoTUFTS19BUlJBWV9TSVpFX01JTiAqIDIpICYm
Ci0JICAgIG1hX2NvdW50IDw9IChtYS0+bWF4IC8gMykpCi0JCXRibF9tYXNrX2FycmF5X3JlYWxs
b2ModGJsLCBtYS0+bWF4IC8gMik7Ci19Ci0KLS8qIFJlbW92ZSAnbWFzaycgZnJvbSB0aGUgbWFz
ayBsaXN0LCBpZiBpdCBpcyBub3QgbmVlZGVkIGFueSBtb3JlLiAqLwotc3RhdGljIHZvaWQgZmxv
d19tYXNrX3JlbW92ZShzdHJ1Y3QgZmxvd190YWJsZSAqdGJsLCBzdHJ1Y3Qgc3dfZmxvd19tYXNr
ICptYXNrKQotewotCWlmIChtYXNrKSB7Ci0JCS8qIG92cy1sb2NrIGlzIHJlcXVpcmVkIHRvIHBy
b3RlY3QgbWFzay1yZWZjb3VudCBhbmQKLQkJICogbWFzayBsaXN0LgotCQkgKi8KLQkJQVNTRVJU
X09WU0woKTsKLQkJQlVHX09OKCFtYXNrLT5yZWZfY291bnQpOwotCQltYXNrLT5yZWZfY291bnQt
LTsKLQotCQlpZiAoIW1hc2stPnJlZl9jb3VudCkKLQkJCXRibF9tYXNrX2FycmF5X2RlbF9tYXNr
KHRibCwgbWFzayk7Ci0JfQotfQotCiAvKiBNdXN0IGJlIGNhbGxlZCB3aXRoIE9WUyBtdXRleCBo
ZWxkLiAqLwogdm9pZCBvdnNfZmxvd190YmxfcmVtb3ZlKHN0cnVjdCBmbG93X3RhYmxlICp0YWJs
ZSwgc3RydWN0IHN3X2Zsb3cgKmZsb3cpCiB7Ci0Jc3RydWN0IHRhYmxlX2luc3RhbmNlICp0aSA9
IG92c2xfZGVyZWZlcmVuY2UodGFibGUtPnRpKTsKLQlzdHJ1Y3QgdGFibGVfaW5zdGFuY2UgKnVm
aWRfdGkgPSBvdnNsX2RlcmVmZXJlbmNlKHRhYmxlLT51ZmlkX3RpKTsKLQotCUJVR19PTih0YWJs
ZS0+Y291bnQgPT0gMCk7Ci0JaGxpc3RfZGVsX3JjdSgmZmxvdy0+Zmxvd190YWJsZS5ub2RlW3Rp
LT5ub2RlX3Zlcl0pOwotCXRhYmxlLT5jb3VudC0tOwotCWlmIChvdnNfaWRlbnRpZmllcl9pc191
ZmlkKCZmbG93LT5pZCkpIHsKLQkJaGxpc3RfZGVsX3JjdSgmZmxvdy0+dWZpZF90YWJsZS5ub2Rl
W3VmaWRfdGktPm5vZGVfdmVyXSk7Ci0JCXRhYmxlLT51ZmlkX2NvdW50LS07Ci0JfQotCi0JLyog
UkNVIGRlbGV0ZSB0aGUgbWFzay4gJ2Zsb3ctPm1hc2snIGlzIG5vdCBOVUxMZWQsIGFzIGl0IHNo
b3VsZCBiZQotCSAqIGFjY2Vzc2libGUgYXMgbG9uZyBhcyB0aGUgUkNVIHJlYWQgbG9jayBpcyBo
ZWxkLgotCSAqLwotCWZsb3dfbWFza19yZW1vdmUodGFibGUsIGZsb3ctPm1hc2spOworCXRhYmxl
X2luc3RhbmNlX3JlbW92ZSh0YWJsZSwgZmxvdyk7CiB9CiAKIHN0YXRpYyBzdHJ1Y3Qgc3dfZmxv
d19tYXNrICptYXNrX2FsbG9jKHZvaWQpCg==
--0000000000007782630595649544--
